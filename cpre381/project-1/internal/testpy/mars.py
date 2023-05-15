import subprocess
import os

mars_path = 'internal/Mars/MARS_CPRE381.jar'

def generate_hex(asm_file_path):
    '''
    uses mars to generate:
        - temp/imem.hex
        - temp/dmem.hex

    accepts path to assembly file as input and does no error checking because the simulation
    should have been run first guarenteeing the program will assemble.
    '''

    # Use check_output instead of call to supress output
    subprocess.check_output(
        ['java','-jar',mars_path,'a','dump','.text','HexText','temp/imem.hex',asm_file_path],
        )

    # create the dump file in case no data mem dump is generated
    open('temp/dmem.hex','w').close()

    # Use check_output instead of call to supress output
    subprocess.check_output(
        ['java','-jar',mars_path,'a','dump','.data','HexText','temp/dmem.hex',asm_file_path],
        )

    # I am not concerned with error codes since we have a guarentee the simulation runs from run_mars_sim()

    
def run_sim(asm_file=None):
    '''
    Simulates Assembly file in MARS. Guarentees that a valid assembly file is given or else it
    will call continue to prompt user.

    Returns the path to the correct assembly file.
    '''

    if asm_file:
        path = asm_file
    else:
        print('Please provide the assembly file to run.')
        print('Use unix style paths like: mips/addiSeq.s')
        path = input('>').strip()

    # Try again if invalid file was provided
    if not os.path.isfile(path):
        print('Invalid path to assembly file\n')
        return run_sim()

    # open in write mode
    with open('temp/mars_dump.txt','w') as f:
        subprocess.call(
            ['java','-jar',mars_path,'nc',path],
            stdout=f
            )

    # Re-opens temp/mars_dump.txt to check for errors
    mars_err = check_mars_dump()

    if mars_err:
        # if there is an issue, with the sim, we should call this method again recursively

        print('\nAssembly file did not correctly simulate in Mars:')
        print(mars_err)

        if asm_file:
            print('Please enter file manually')

        print()
        return run_sim()
    else:
        return path


def check_mars_dump():
    '''
    Checks the Mars Dump to ensure that no errors occourred
    Returns None if no error occourred, a string otherwise
    '''

    # Mars does not seem provide non-zero error codes, so we need to look at the dump to check for errors
    # We defensively check for the assembly file not existing, so an invalid argument should not be possible
    # This method scans the dump and checks for lines starting with 'Error '

    # for each line, check if it starts with error
    with open('temp/mars_dump.txt') as f:
        for line in f:
            if line.startswith('Error '):
                return line.rstrip()

    return None
