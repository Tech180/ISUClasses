import subprocess
import os
import re
import shutil
import time
import config_parser
from pathlib import Path

# used to see if output may have timed out but outputted correctly (meaning no halt signal)
expected_firstline = re.compile(r'In clock cycle: (?P<cycle>[0-9]+)')

modelsim_path = ""

def compile():
    '''
    Compiles everything in src into work. Assumes directory is present. Open's notepad with any compile errors

    Returns True if compilation succeeded
    '''

    print('starting compilation...')

    # Remove the work before compilation to ensure a blank slate and prevent potential issues.
    # If work is not removed, and the last run was terminated unexpectedly, compilation errors
    # will occour
    try:
        shutil.rmtree('internal/work') # delete a non empty directory
    except FileNotFoundError as e:
        pass # It is fine if the directory already doesn't exist
    except Exception as e:
        print('Could not successfully delete work folder, perhaps it is open in another program?')
        return False

    # Create work folder for compiled work
    try:
        subprocess.check_output( # use check_output to suppress any output
            [f'{modelsim_path}/vlib','internal/ModelSimContainer/work']) 
    except:
        print("could not successfully create work folder")
        return False

    try:
        with open('temp/vcom_compile.log','w') as f:
            exit_code = subprocess.call(
                [f'{modelsim_path}/vcom','-2008','-work','internal/ModelSimContainer/work','src/*.vhd'],
                stdout=f,
                timeout=60
            )
    except subprocess.TimeoutExpired:
        print('Compilation timed out.\n')
        print('Look at temp/vcom_compile.log')
        return False

    if(exit_code != 0):
        print(f'could not compile successfully, got exit code {exit_code}')
        
        # Use Popen to start notepad in a non-blocking manner with the compile error
        print('Look at temp/vcom_compile.log')
        return False

    print('Successfully compiled vhdl')
    return True

def sim(timeout=30):
    '''
    Simulates testbench. All work should be compiled before this method is called
    Returns True if the simulation was successful, otherwise False
    '''

    print('Starting VHDL Simulation...')
    
    try:

        with open('temp/vsim.log','w') as sim_log:
            exit_code = subprocess.call(
                [f'{modelsim_path}/vsim','-c','-voptargs=+acc','tb','-do','../testpy/modelsim_framework.do'],
                stdout=sim_log,
                stderr=sim_log,
                cwd='internal/ModelSimContainer/', #Run this process in the same dir as the work folder
                timeout=timeout # If the do file doesn't reach the 'quit' we need to manually kill the process
            )

        # check if process exited with error.
        if(exit_code != 0):
            print(f'could not simulate successfully, got exit code {exit_code}')

            # Use Popen to start notepad in a non-blocking manner with the sim error
            print('Look at temp/vsim.log')
            return False

    except subprocess.TimeoutExpired:

        if timeout_is_nohalt():
            print('** Warning: Simulation timed out, but produced some valid output, most likely the halt signal is incorrect or the application contains an infinite loop **')
        else:
            busy_move('internal/ModelSimContainer/dump.txt','temp/modelsim_dump.txt',missingok=True)
            busy_move('internal/ModelSimContainer/vsim.wlf', 'temp/vsim.wlf', missingok=True)

            # close the simulation with a failure since the simulation didn't produce a valid output
            print('Simulation timed out (if you think this was a mistake you can increase the time to more than 30 seconds explicitly via --sim-timeout)\n')
            print('Look at temp/vsim.log')
            
            return False

    # busy_move instead of shutil.move because in the case where the sim timed-out, but produced output
    # there is usually a permission error, but we can retry until it works. (or a timeout is reached)
    busy_move('internal/ModelSimContainer/dump.txt','temp/modelsim_dump.txt',missingok=False)
    busy_move('internal/ModelSimContainer/vsim.wlf', 'temp/vsim.wlf',missingok=False)

    print('Successfully simulated program!')
    return True


def timeout_is_nohalt():
    '''
    Opens dump file to check if file is formatted correctly despite process timing out.
    This would indicate that no halt signal was implemented, but simulation was correct otherwise.

    Retuns False if halt didn't cause the time out
        , True if it may have times out because of halt
    '''
    if not os.path.isfile('internal/ModelSimContainer/dump.txt'):
        return False

    with open('internal/ModelSimContainer/dump.txt') as f:
        firstline = f.readline()
    
    return expected_firstline.match(firstline)

def busy_move(src,dest,timeout=5,missingok=False):
    '''
    Sometimes when modelsim is timed out it still holds some file resources, preventing the files
    from being deleted or moved. This is just shutil.move wrapped so that it busy-waits by retrying
    until the resource is released.
    '''
    s = time.time()
    while True:
        try:
            shutil.move(src,dest)
            return
        except FileNotFoundError as e:
            if not missingok: 
                raise e # re-raise if user did not allow file to not exist
        except PermissionError as e:
            if time.time() - s > timeout:
                raise e  # stop trying if we have reached the timeout
        
def is_installed():
    '''
    Returns True if modelsim is installed on the computer in the expected location
    Checkes the config file to verify if a custom path should be used.
    '''

    config_parameters = config_parser.read_config()
    global modelsim_path
    custom_path = False
    custom_path_found = False

    for x in config_parameters:
        if "MODELSIM PATH" in x[0].upper():
            modelsim_path = x[1]
            custom_path_found = True

    
    if custom_path_found == False:
        modelsim_path = r'C:\Program Files\modeltech64_2019.3\win64'
        print("Changing ModelSim Path to default : ",modelsim_path)
    else:
        print("ModelSim Path : ",modelsim_path)

    is_dir = os.path.isdir(modelsim_path)

    return is_dir
