
from pathlib import Path

def read_config():
    # Reads the Config.txt file and returns the parameters as a touple list with the parameter name and parameter value.
    
    config_path = Path("config.txt").resolve()

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