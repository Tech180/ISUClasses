import argparse
import re
import os
import traceback
import datetime
import hashlib
import dump_compare, mars, modelsim, run_gui
from pathlib import Path

def main():
    '''
    Main method for the test framework
    '''
    # Algorithm:
    # 1) parse arguments
    # 2) vaidate what we can
    # 3) run MARS sim
    # 4) compile student vhdl
    # 5) generate hex with MARS
    # 6) sim student vhdl
    # 7) compare output

    os.makedirs('temp',exist_ok=True)

    # 1) parse arguments
    # global options
    # options = parse_args()

    # 2) validate what we can
    missing_file = check_project_files_exist()
    if missing_file:
        print(f'\nCould not find {missing_file}')
        print('\nprogram is exiting\n')
        input("Press Enter to Exit...")
        exit()

    if not modelsim.is_installed():
        print('\nModelsim does not seem to be installed in the expected location')
        print('\nPlease Verify the installation path in the config.txt is correct')
        print('\nProgram is exiting\n')
        input("Press Enter to Exit...")
        exit()

    if not check_vhdl_present():
        print('\nOops! It doesn\'t look like you\'ve copied your processor into src')
        input("Press Enter to Exit...")
        return


    warn_tb_checksum()


    # Implement GUI, and auto run here. 

    run_gui.guiMain()

    input("Press Enter To Exit...")

#This is called to run all the provided asm files.
def queueSimulation(asm_files, simOptions):
    print("Adding Asm Files to Queue\n")
    
    for x in asm_files:
        simOptions['asm-path']=x
        runSimulation(x,simOptions)


def runSimulation(asm_Path, options):

    # 3) run MARS sim
    print("Starting Simulation for :",options['asm-path'])
    options['asm-path'] = mars.run_sim(asm_file=asm_Path)

    # 4) compile student vhdl
    if options['compile']:
        compile_success = modelsim.compile()
        if not compile_success:
            print("Compile Failed")
            return
    else:
        print('Skipping compilation')

    # 5) generate hex with MARS
    mars.generate_hex(options['asm-path'] )
    
    # 6) sim student vhdl
    sim_success = modelsim.sim(timeout=options['sim-timeout'])
    if not sim_success:
        return

    # 7) compare output
    compare_dumps(options)

    print("")

    #input("Press Enter To Exit...")




def check_vhdl_present():
    '''
    Checks if there are any VHDL files present in the src folder other than the provided
    top-level design. prints a warning if there is a file without the .vhd extension

    Returns True if other files exist
    '''
    
    # get a list of all the file names in the dir
    with os.scandir(path='src/') as scan:
        src_dir = [f.name for f in scan if f.is_file()]

    # print a warning if there is at least 1 non .vhdd file
    non_vhd = next((f for f in src_dir if f.endswith('.vhdl')),None)
    if non_vhd:
        print('** Warining: your source directory contains a file without the .vhd extension **')
        print(f'** {non_vhd} will be ignored because it does not have the .vhd extension **')

    expected = {'tb.vhd','mem.vhd','MIPS_Processor.vhd'}

    # return True if at least 1 new .vhd file exists
    is_student_vhd = lambda f: f.endswith('.vhd') and f not in expected
    return any((True for x in src_dir if is_student_vhd(x)))

def parse_args():
    '''
    Parse commnd line arguments into a dictionary, and return that dictionary.

    The returned dictionary has the following keys and types:
    - 'asm-path': str
    - 'max-mismatches': int > 0 
    - 'compile': bool
    '''
    parser = argparse.ArgumentParser()
    parser.add_argument('--asm-file', help='Relative path to assembly file to simulate using unix style paths.')
    parser.add_argument('--max-mismatches', type=check_max_mismatches ,default=3, help='Number of incorrect instructions to print before the program claims failure, default=3')
    parser.add_argument('--nocompile', action='store_true', help='flag used to disable compilation in order to save time')
    parser.add_argument('--sim-timeout',type=check_sim_timeout, default=30, help='change the ammount of time before simulation is forcefully stopped')
    args = parser.parse_args()

    options = {
        'asm-path': args.asm_file,
        'max-mismatches': args.max_mismatches,
        'compile': not args.nocompile,
        'sim-timeout': args.sim_timeout
    }

    return options

def check_sim_timeout(v):
    ivalue = int(v)
    if ivalue <= 0:
        raise argparse.ArgumentTypeError('--sim-timeout should be a positive integer')
    return ivalue

def check_max_mismatches(v):
    ivalue = int(v)
    if ivalue <= 0:
        raise argparse.ArgumentTypeError('--max-mismatches should be a positive integer')
    return ivalue

def check_project_files_exist():
    '''
    Returns None if all required files exist, otherwise returns path to missing file
    '''
    expected_files = [
        'internal/Mars/MARS_CPRE381.jar',
        'internal/testpy/modelsim_framework.do',
        'src/tb.vhd',
        'src/MIPS_Processor.vhd',
        'config.txt'
    ]
    for path in expected_files:
        if not os.path.isfile(path):
            return path

    return None

def warn_tb_checksum():
    ''' 
    Prints a warning if the testbench has been modified according to a md5 checksum .
    Assumes file exists. Allows both LF and CRLF line endings.
    '''
    expected = {
        b'\xc7\x12\x00\xc3\xaf\xe8>\r\xa3\xdd\xf4g\x90\xcde\xdf'
        }

    # copy these lines to generate new expected checksums
    with open('src/tb.vhd','rb') as f:
        observed = hashlib.md5(f.read()).digest()

    if observed not in expected:
        print('\n** Warning: It looks like src/tb.vhd has been modified. It will be graded using the version from the release **')
        print(f'\n ** Expected: {str(expected)} **')
        print(f'\n ** Observed: {observed} **')


def compare_dumps(options):
    '''
    Compares dumps ans prints the results to the console
    '''

    student_dump = 'temp/modelsim_dump.txt'
    mars_dump = 'temp/mars_dump.txt'

    # use user mismatches if the option was specified
    mismatches = options['max-mismatches']
    if not mismatches:
        mismatches = 3

    compare_output = [] # accumulator for dump output
    def compare_out_function(compare_line): # accepts each line of compare output and saves it to an array 
        compare_output.append(compare_line)

    dump_compare.compare(student_dump,mars_dump,max_mismatches=mismatches,outfunc=compare_out_function) # captures the output

    # print compare to console
    for line in compare_output:
        print(line)

    # print compare to file
    try:
        with open('temp/compare.txt','w') as f:
            f.writelines((f'{x}\n' for x in compare_output)) # map each line to itself + line endings
    except:
        print('** Warning: failed to write comparison file temp/compare.txt **')


def log_exception():
    ''' Writes the last exception thrown to the error log file'''
    
    with open('temp/errors.log','a') as f:
        f.write(f'\nException caught at {datetime.datetime.now()}:\n')
        traceback.print_exc(file=f)

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt: #exit gracefully since this is common
        exit(1)
    except Exception:
        log_exception()
        print('Program exited with unexpected exception.')
        print('Please post to the Project Testing Framework discussion, and attach temp/errors.log')


