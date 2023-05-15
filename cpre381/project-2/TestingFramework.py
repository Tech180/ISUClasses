import os
import subprocess
from pathlib import Path

os.environ['LM_LICENSE_FILE'] = '27008@io.ece.iastate.edu:1717@io.ece.iastate.edu'
test_framework_path = r'internal/testpy/test_framework.py'
synthesis_framework_path = Path(r'internal/snthpy/synthesis.py').resolve()
VDI_Python = r'C:\Python\python.exe'
LAB_Python = r'C:\Program Files (x86)\Python37-32\python.exe'
TLA_Python = r'/usr/local/mentor/calibre/bin/python3'

def main():
    
    #Reads the parameters listed in config.txt
    parameters = read_config()

    python_path = ""
    custom_path_found = True

    #Looks through the parameters for python path and custom python.
    for x in parameters:
        if "PYTHON PATH" in x[0].upper():
            python_path = x[1]
            custom_path_found = True
        if "PYTHON_TLA PATH" in x[0].upper():
            if os.path.isfile(x[1]):
                python_path = x[1]
                custom_path_found = True
        

    #If it doesnt find the custom path parameter or it doesnt find custom python to be true, then it attempts to use the default lab/VDI Python installs
    if custom_path_found == False:
        #Try Default Paths
        VDI_Path_Check = os.path.isfile(VDI_Python)
        LAB_Path_Check = os.path.isfile(LAB_Python)

        #If either the VDI or LAB computer paths are correct, then it runs test_framework.py
        if VDI_Path_Check == True or LAB_Path_Check == True:

            if VDI_Path_Check == True:
                python_path = VDI_Python
            if LAB_Path_Check == True:
                python_path = LAB_Python

            subprocess.Popen([python_path,str(test_framework_path)])

        #Else it prints a brief troubleshooting message and exits
        else:
            print("Python not found")
            print("If you are using the Lab or VDI computers, Contact the lab TAs")
            input("Press Enter to Exit...")

    #If the custom path is found, use it.
    else:

        valid_path = os.path.isfile(python_path)

        if valid_path == True:
            print("Python Path : ",python_path)
            subprocess.Popen([python_path,str(test_framework_path)])
        
        else:
            print("Python not found at custom Path : ",python_path)
            print("If you are using a custom python install, verify the path is correct in config.txt")
            print("If you are using the Lab or VDI computers, Contact the lab TAs")
            input("Press Enter to Exit...")

def read_config():
    # Reads the Config.txt file and returns the parameters as a touple list with the parameter name and parameter value.
    # The Config.txt file needs to be in the same directory as this module
    
    config_path = Path("config.txt").resolve()

    config_found = os.path.isfile(config_path)

    if not config_found:
        print("Config.txt File Not Found")
        input("Press Enter to Exit...")
        return

    f = open(config_path,"r")

    config_parameters = []

    line_number = 0

    for x in f:
        line_number = line_number + 1
        #print(line_number," : ",x)
        try:

            if not len(x.strip()) == 0:
                tempStrings = x.split('=')
                tempStrings[0] = tempStrings[0].strip()
                tempStrings[1] = tempStrings[1].strip()
                #print(tempStrings[0]," : ",tempStrings[1])
                config_parameters += [(tempStrings[0], tempStrings[1])]
        except:
            print("Config.txt File Not Formated Correctly")
            print("Please Verify Format of Line ",line_number)

    return config_parameters




if __name__ == '__main__':
    main()
