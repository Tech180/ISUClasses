import subprocess
import os
import datetime as dt
import generate_project as gp
import config_parser

r'''
:temporary script for testing
C:\intelFPGA\18.1\quartus\bin64\quartus_map --read_settings_files=on --write_settings_files=off qs2 -c qs2

C:\intelFPGA\18.1\quartus\bin64\quartus_fit --read_settings_files=off --write_settings_files=off qs2 -c qs2
C:\intelFPGA\18.1\quartus\bin64\quartus_asm --read_settings_files=off --write_settings_files=off qs2 -c qs2
C:\intelFPGA\18.1\quartus\bin64\quartus_sta --sdc="qs2.sdc" qs2 --do_report_timing
'''

quartus_bin_dir = r'C:\intelFPGA\18.1\quartus\bin64'

#Checks Config File for custom path, If not found it uses default path above
config_parameters = config_parser.read_config()

for x in config_parameters:
        if "QUARTUS PATH" in x[0].upper():
            quartus_bin_dir = x[1]
        if "QUARTUS_TLA PATH" in x[0].upper():
            if os.path.isdir(x[1]):
                quartus_bin_dir = x[1]


def build_all(dir='internal/QuartusWork'):
    pname = gp.project_name

    starttime = dt.datetime.now()

    print(f'\nStarting compilation at {str(starttime)}\n')

    with open('temp/synth_error.log','w') as synth_log:

        # starting mapping
        exit_code = subprocess.call(
            [f'{quartus_bin_dir}/quartus_map','--read_settings_files=on','--write_settings_files=off',pname,'-c',pname],
            cwd=dir,
            stdout = synth_log,
            stderr = synth_log
        )

        if exit_code != 0:
            print('Error during compilation or mapping')
            return False

        # starting fitting
        exit_code = subprocess.call(
            [f'{quartus_bin_dir}/quartus_fit','--read_settings_files=on','--write_settings_files=off',pname,'-c',pname],
            cwd=dir,
            stdout = synth_log,
            stderr = synth_log
        )

        if exit_code != 0:
            print('Error during fitting')
            return False

        # starting assembly
        exit_code = subprocess.call(
            [f'{quartus_bin_dir}/quartus_asm','--read_settings_files=on','--write_settings_files=off',pname,'-c',pname],
            cwd=dir,
            stdout = synth_log,
            stderr = synth_log
        )

        if exit_code != 0:
            print('Error during assembly')
            return False

    # generate timing
    with open('temp/timing_dump.txt','w') as timing_log:
        exit_code = subprocess.call(
            [f'{quartus_bin_dir}/quartus_sta',f'--sdc={pname}.sdc',pname,'--do_report_timing'],
            cwd=dir,
            stdout = timing_log
        )

        if exit_code != 0:
            print('Error during assembly')
            return False

    endtime = dt.datetime.now()
    print('\nTiming generation complete!')
    print(f'completed in {str(endtime-starttime)}')

    return True

