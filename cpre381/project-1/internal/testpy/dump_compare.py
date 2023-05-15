# dump_compare.py compares the output of the Test Framework provided Testbench and MARS. 
# Usase is as follows (works in both python 2 and 3, but tested with python 2.7):
# 	python dump_compare.py <testbench_file> <mars_file> <max_mismatches>
# Example Usage:
# 	python dump_compare.py dump.txt student_MARSdump.txt 10
#
# NOTE: max_mismatches need not be provided, it will default to 2.

import sys
import re
import time

mars_firstline_re = re.compile(r'[0-9]*\[inst #(?P<num>[0-9]+)\] (?P<instr>[0-9$a-z ,\-\(\)]+)') # statrts with [0-9]* to ignore known mars issue
student_firstline_re = re.compile(r'In clock cycle: (?P<cycle>[0-9]+)')
register_write_re = re.compile(r'Register Write to Reg: (?P<reg>[0-9A-Fa-fxX]+) Val: (?P<val>[0-9A-Fa-fxX]+)')
memory_write_re = re.compile(r'Memory Write to Addr: (?P<addr>[0-9A-Fa-fxX]+) Val: (?P<val>[0-9A-Fa-fxX]+)')

def main():
    max_mismatches = 2

    if not 3 <= len(sys.argv) <= 4:
        print('Improper usage, expecting python dump_compare.py <testbench_file> <mars_file> <max_mismatches>')
        print('Note: max_mismatches will default to 2 if not set')
        return 1

    student_file_path = sys.argv[1]
    mars_file_path = sys.argv[2]
    if len(sys.argv) == 4:
        try:
            max_mismatches = int(sys.argv[3])
        except (ValueError, TypeError):
            print('Invalid Argument in position 4, only numbers are accepted')
            return 1
        
    print('Maximum Number of Mismatches Accepted: ' + str(max_mismatches))
    print('')

    compare(student_file_path,mars_file_path,max_mismatches=max_mismatches)

class StudentReader:
    '''
    Wraps a mars dump file object so that we can separate the skipping logic from the comparison logic
    '''
    nop_re = re.compile(r'Register Write to Reg: 0x00.*') 

    def __init__(self,path):
        self.path = path
        self.f = open(path, "r")
        self.fArr = []
        #for l in self.f:
        #    self.fArr.append(l.strip())
        #self.f.close()
        #self.f = open(path,"r")

    def read_next(self,skipnop=False): # make skipnop mandatory
        '''
        Returns the next 2 lines of the dump (ignoring $zero writes)..
        first return value (fline) is guarenteed nothing, and can be null
        second return value (sline) is guarenteed to not be a $zero write, and can be null
        third return value (tline) can be null 
        '''
        while True:
            fline = self.f.readline().strip()
            fline_search = student_firstline_re.search(fline)
            if not fline_search and not("stop" in fline):
                continue # if the firstline is unknown try agaim
            #print(fline)
            sline = self.f.readline().strip()
            #print(sline)
            tline = self.f.readline()
            tline_length = len(tline)
            tline.strip()
            #print(tline)
            
            if not skipnop or not sline:
                return fline, sline, tline
            elif self.nop_re.fullmatch(sline):
                self.f.seek(self.f.tell()-tline_length-0) 
                continue # if instruction is a nop try again
            else:
                self.f.seek(self.f.tell()-tline_length-0) 
                return fline, sline, tline # common case: instruction is valid

    def genStruct(self, structLen, skipnop=False):
        count = 0
        searchLen = 0
        structArr = []
        while count < len(self.fArr):
            instructionDict = {}
            if count == len(self.fArr)-1:
                instructionDict['fline'] = self.fArr[-1]
                structArr.append(instructionDict)
                break
            if searchLen >= structLen:
                break
            fline = self.fArr[count]
            if not student_firstline_re.search(fline):
                count+=1
                continue
            sline = self.fArr[count+1]
            if not skipnop or not sline:
                count+=1
                instructionDict["fline"] = fline
                structArr.append(instructionDict)
                searchLen+=1
                continue
            elif self.nop_re.fullmatch(sline):
                count+=2
                continue
            tline = self.fArr[count+2]
            if "Arithmetic" in tline:
                instructionDict["fline"] = fline
                instructionDict["sline"] = sline
                instructionDict["tline"] = tline
                structArr.append(instructionDict)
                searchLen+=1
                count+=3
                continue
            else:
                instructionDict["fline"] = fline
                instructionDict["sline"] = sline
                structArr.append(instructionDict)
                searchLen+=1
                count+=2
     
        return structArr
        
        
    def close(self):
        self.f.close()

class MarsReader:
    '''
    Wraps a mars dump file object so that we can separate the skipping logic from the comparison logic
    '''
    # instructions to ignore in the 'instr' group of mars_firstline_re
    ignored = ['syscall','jr ','j ','beq ','bne ','nop','halt']
    nop_re = re.compile(r'Register Write to Reg: 0x00.*')
    
    def __init__(self,path):
        self.path = path
        self.f = open(path,"r")
        self.fArr = []
        #for l in self.f:
        #    self.fArr.append(l.strip())
        #self.f.close()
        #self.f = open(path,"r")

    def read_next(self,skipnop=False):
        '''
        Reads the next unignored instruction (including $zero writes).
        first return value (fline) is guarenteed to either be null or match mars_firstline_re
        second return value (sline) is guarenteed to be non-null
        third return value (tline) can be null
        '''

        while True:

            fline = self.f.readline().strip()
            #print(fline)

            if not fline:
                return None, '', '' # if there is no more input, output nothing
            
            
            fline_search = mars_firstline_re.search(fline)
            if not fline_search:
                continue # if the firstline is unknown try agaim
            
            
            ignored_instr = any((x in fline_search.group('instr') for x in self.ignored))
            if ignored_instr:
                continue # if the firstline is an ignored instruction try again
            
            sline = self.f.readline().strip()

            if not skipnop or not sline:
                return fline, '', ''
            elif self.nop_re.fullmatch(sline):
                continue # if there is a zero register write try again
            
            tline = self.f.readline()
            tline_length = len(tline)
            tline = tline.strip()

            if not skipnop or not tline:
                return fline, sline, ''
                
            else:
                self.f.seek(self.f.tell()-tline_length-0) 
                return fline, sline, tline # common case of both lines being valid

    '''
    Generate list of dictionaries containing all relevant information regarding that specific
    cycle/instruction execution.
    '''
    def genStruct(self, skipnop=False):
        count = 0
        structArr = []
        while count < len(self.fArr):
            instructionDict = {}
            if count == len(self.fArr)-2:
                instructionDict['fline'] = "Execution is stopping!"
                structArr.append(instructionDict)
                break
            fline = self.fArr[count]
            if not mars_firstline_re.search(fline):
                count+=1
                continue
            if any((x in mars_firstline_re.search(fline).group('instr') for x in self.ignored)):
                count+=1
                continue
            sline = self.fArr[count+1]
            
            if not skipnop or not sline:
                instructionDict["fline"] = fline
                structArr.append(instructionDict)
                count+=1
                continue
            elif self.nop_re.fullmatch(sline):
                count+=2
                continue
            
            tline = self.fArr[count+2]
            if not skipnop or not tline:
                count+=2
                instructionDict["fline"] = fline
                instructionDict["sline"] = sline
                structArr.append(instructionDict)
                continue
            elif "Arithmetic" in tline:
                count+=3
                instructionDict["fline"] = fline
                instructionDict["sline"] = sline
                instructionDict["tline"] = tline
                structArr.append(instructionDict)
                continue
            else:
                count+=2
                instructionDict["fline"] = fline
                instructionDict["sline"] = sline
                structArr.append(instructionDict)
        return structArr
        
    def close(self):
        self.f.close()

def new_compare(student_file_path, mars_file_path, max_mismatches=2, outfunc=print, help=True):
    '''
    Compares the modelsim and mars dump files for a program
    Returns True if sim succeeded, false otherwise
    This method is a temporary fix until we can track down bug in legacy
    compare code
    '''

    mars_syscall = False
    cur_mismatches = 0
    overflow_count = 0
    iter_count = 0
    
    student_reader = StudentReader(student_file_path)
    mars_reader = MarsReader(mars_file_path)
    mars_arr = mars_reader.genStruct(skipnop=True)
    student_arr = student_reader.genStruct(len(mars_arr), skipnop=True)
    
    max_iter = len(student_arr)
    
    print("Beginning comparison")
    while cur_mismatches < max_mismatches:
        print(cur_mismatches, max_mismatches)
        '''
        Check last operation for halt message
        '''
        if iter_count == max_iter-1:

            '''
            Check if student ends early
            '''
            if len(student_arr) < len(mars_arr):
                mars_firstline_search = mars_firstline_re.search(mars_arr[iter_count]['fline'])
                mars_secondline = mars_arr['sline']
                cur_mismatches = cur_mismatches + 1
                if cur_mismatches == 1:
                    outfunc('Oh no...\n')
                outfunc('Cycle: NA')
                outfunc('MARS Continues Execution, Student Ends Early')
                outfunc(f'MARS instruction number: {mars_firstline_search.group("num")}\tInstruction: {mars_firstline_search.group("instr")}')
                outfunc(f'MARS: {mars_secondline}')
                outfunc('Student: Execution Ended\n')
            elif not("Execution" in student_arr[-1]['fline']):
                '''
                Check if studnet continues execution
                '''
                cur_mismatches = cur_mismatches + 1
                student_firstline_search = student_firstline_re.search(student_arr[iter_count]['fline'])
                student_secondline =  student_arr['sline']
                if cur_mismatches == 1:
                    outfunc('Oh no...\n')
                outfunc(f'Cycle: {student_firstline_search.group("cycle")}')
                outfunc('MARS Stopped Execution, Student Improperly Continues')
                outfunc('MARS instruction number: NA\tInstruction: NA')
                outfunc('MARS: Execution Ended')
                outfunc(f'Student: {student_secondline}\n')
                
            else:
                break
        else:
            mars_firstline = mars_arr[iter_count]['fline']
            mars_secondline = mars_arr[iter_count]['sline']
            mars_firstline_search = mars_firstline_re.search(mars_firstline)
            mars_secondline_search = memory_write_re.search(mars_secondline)
            mars_reg_write = False
            if "Register" in mars_arr[iter_count]['sline']:
                mars_reg_write=True
                mars_secondline_search = register_write_re.search(mars_arr[iter_count]['sline'])

            student_firstline = student_arr[iter_count]['fline']
            student_secondline = student_arr[iter_count]['sline']
            student_firstline_search = student_firstline_re.search(student_firstline)
            student_secondline_search = memory_write_re.search(student_secondline)
            student_reg_write = False
            if "Register" in student_arr[iter_count]['sline']:
                student_reg_write=True
                student_secondline_search = register_write_re.search(student_secondline)

            if ("tline" in mars_arr[iter_count].keys()) and ("tline" in student_arr[iter_count].keys()):
                overflow_count = overflow_count + 1
                outfunc("Arithmetic Overflow Detected in Cycle: " + student_firstline_search.group("cycle"))

            if student_reg_write == mars_reg_write:
                if mars_reg_write:
                    if not (mars_secondline_search.group('val') == student_secondline_search.group('val') and mars_secondline_search.group('reg') == student_secondline_search.group('reg')):
                        cur_mismatches = cur_mismatches + 1
                        if cur_mismatches == 1:
                            outfunc('Oh no...\n')
                        outfunc(f'Cycle: {student_firstline_search.group("cycle")}')
                        outfunc('Incorrect Write to Register File')
                        outfunc(f'MARS instruction number: {mars_firstline_search.group("num")}\tInstruction: {mars_firstline_search.group("instr")}')
                        outfunc(f'MARS: {mars_secondline}')
                        outfunc(f'Student: {student_secondline}\n')
                else:
                    if not (mars_secondline_search.group('val') == student_secondline_search.group('val') and mars_secondline_search.group('addr') == student_secondline_search.group('addr')):
                        cur_mismatches = cur_mismatches + 1
                        if cur_mismatches == 1:
                            outfunc('Oh no...\n')
                        outfunc(f'Cycle: {student_firstline_search.group("cycle")}')
                        outfunc('Incorrect Write to Memory')
                        outfunc(f'MARS instruction number: {mars_firstline_search.group("num")}\tInstruction: {mars_firstline_search.group("instr")}')
                        outfunc(f'MARS: ' + mars_secondline)
                        outfunc(f'Student: {student_secondline}\n')
            else:
                cur_mismatches = cur_mismatches + 1
                if cur_mismatches == 1:
                    outfunc('Oh no...\n')
                outfunc(f'Cycle: {student_firstline_search.group("cycle")}')
                outfunc('Writing to Different Components')
                outfunc(f'MARS instruction number: {mars_firstline_search.group("num")}\tInstruction: {mars_firstline_search.group("instr")}')
                outfunc(f'MARS: {mars_secondline}')
                outfunc(f'Student: {student_secondline}\n')
        
        iter_count+=1
              
    mars_reader.close()
    student_reader.close()

    #Print final message
    if cur_mismatches == 0:
        outfunc('Victory!! Your processes matches MARS expected output with no mismatches!!')
        return True
    elif cur_mismatches < max_mismatches:
        outfunc(f'Almost! your processor completed the program with  {cur_mismatches}/{max_mismatches} allowed mismatches')
        if help:
            outfunc(helpinfo.format(student_file_path,mars_file_path))
        return False
    else:
        outfunc(f'You have reached the maximum mismatches ({cur_mismatches})')
        if help:
            outfunc(helpinfo.format(student_file_path,mars_file_path))
        return False

def compare(student_file_path, mars_file_path, max_mismatches=2, outfunc=print, help=True):
    '''
    Compares the modelsim and mars dump files for a program
    Returns True if sim succeeded, false otherwise
    '''

    mars_syscall = False
    cur_mismatches = 0
    overflow_count = 0
    
    student_reader = StudentReader(student_file_path)
    mars_reader = MarsReader(mars_file_path)
    
    while cur_mismatches < max_mismatches:
   
        #get mars instruction
        mars_firstline, mars_secondline, mars_thirdline = mars_reader.read_next(skipnop=True) 

        #search mars first line
        if mars_firstline:
            mars_firstline_search = mars_firstline_re.search(mars_firstline)
        
        #check whether the memory or the register file was written
        if mars_firstline and 'Register' in mars_secondline:
            mars_secondline_search = register_write_re.search(mars_secondline)
            mars_reg_write = True
        elif mars_firstline:
            mars_secondline_search = memory_write_re.search(mars_secondline)
            mars_reg_write = False
        
        # read both lines of the student dump
        student_firstline, student_secondline, student_thirdline = student_reader.read_next(skipnop=True)
      
        if student_firstline == 'Execution is stopping!':
            student_firstline = ''
        #search student first line
        if student_firstline:
            student_firstline_search = student_firstline_re.search(student_firstline)
         
        #If arithmetic overflow occurs
        if (student_thirdline.strip() == 'Arithmetic overflow occurred!') and (mars_thirdline.strip() == 'Arithmetic Overflow Detected'):
            overflow_count = overflow_count + 1
            outfunc("Arithmetic Overflow Detected Correctly in Cycle: " + student_firstline_search.group("cycle")+'\n')
        elif (student_thirdline.strip() == 'Arithmetic overflow occurred!') and not(mars_thirdline.strip() == 'Arithmetic Overflow Detected'):
            outfunc("Arithmetic Overflow Detected by the Student but not Mars in Cycle: " + student_firstline_search.group("cycle")+'\n')
        elif not(student_thirdline.strip() == 'Arithmetic overflow occurred!') and (mars_thirdline.strip() == 'Arithmetic Overflow Detected'):
            outfunc("Arithmetic Overflow Detected by the Mars but not the student in Cycle: " + student_firstline_search.group("cycle")+'\n')

        #check whether the memory or the register file was written
        if student_firstline and 'Register' in student_secondline:
            student_secondline_search = register_write_re.search(student_secondline)
            student_reg_write = True
            
        elif student_firstline:
            student_secondline_search = memory_write_re.search(student_secondline)
            student_reg_write = False
  
        #Student continues to execute instructions when mars has completed     
        if (not mars_firstline and student_firstline):
            if not (student_secondline and student_secondline == 'Register Write to Reg: 0x00 Val: 0x00000000' and mars_syscall):
                cur_mismatches = cur_mismatches + 1
                if cur_mismatches == 1:
                    outfunc('Oh no...\n')
                outfunc(f'Cycle: {student_firstline_search.group("cycle")}')
                outfunc('MARS Stopped Execution, Student Improperly Continues')
                outfunc('MARS instruction number: NA\tInstruction: NA')
                outfunc('MARS: Execution Ended')
                outfunc(f'Student: {student_secondline}\n')
        #Student ends execution early
        elif mars_firstline and not student_firstline:
            cur_mismatches = cur_mismatches + 1
            if cur_mismatches == 1:
                outfunc('Oh no...\n')
            outfunc('Cycle: NA')
            outfunc('MARS Continues Execution, Student Ends Early')
            outfunc(f'MARS instruction number: {mars_firstline_search.group("num")}\tInstruction: {mars_firstline_search.group("instr")}')
            outfunc(f'MARS: {mars_secondline}')
            outfunc('Student: Execution Ended\n')

        #Both student and mars stop executing 
        elif not mars_firstline and not student_firstline:
            break
        #Student and mars wrote to either register file or memory:
        else:
            if student_reg_write == mars_reg_write:
                if mars_reg_write:
                    if not (mars_secondline_search.group('val') == student_secondline_search.group('val') and mars_secondline_search.group('reg') == student_secondline_search.group('reg')):
                        cur_mismatches = cur_mismatches + 1   
                        if cur_mismatches == 1:
                            outfunc('Oh no...\n')
                        outfunc(f'Cycle: {student_firstline_search.group("cycle")}')
                        outfunc('Incorrect Write to Register File')
                        outfunc(f'MARS instruction number: {mars_firstline_search.group("num")}\tInstruction: {mars_firstline_search.group("instr")}')
                        outfunc(f'MARS: {mars_secondline}')
                        outfunc(f'Student: {student_secondline}\n')
                else:
                    if not (mars_secondline_search.group('val') == student_secondline_search.group('val') and mars_secondline_search.group('addr') == student_secondline_search.group('addr')):
                        cur_mismatches = cur_mismatches + 1
                        if cur_mismatches == 1:
                            outfunc('Oh no...\n')
                        outfunc(f'Cycle: {student_firstline_search.group("cycle")}')
                        outfunc('Incorrect Write to Memory')
                        outfunc(f'MARS instruction number: {mars_firstline_search.group("num")}\tInstruction: {mars_firstline_search.group("instr")}')
                        outfunc(f'MARS: ' + mars_secondline)
                        outfunc(f'Student: {student_secondline}\n')
            else:
                cur_mismatches = cur_mismatches + 1
                if cur_mismatches == 1:
                    outfunc('Oh no...\n')
                outfunc(f'Cycle: {student_firstline_search.group("cycle")}')
                outfunc('Writing to Different Components')
                outfunc(f'MARS instruction number: {mars_firstline_search.group("num")}\tInstruction: {mars_firstline_search.group("instr")}')
                outfunc(f'MARS: {mars_secondline}')
                outfunc(f'Student: {student_secondline}\n')
    
    mars_reader.close()
    student_reader.close()

    #Print final message
    if cur_mismatches == 0:
        outfunc('Victory!! Your processes matches MARS expected output with no mismatches!!')
        return True
    elif cur_mismatches < max_mismatches:
        outfunc(f'Almost! your processor completed the program with  {cur_mismatches}/{max_mismatches} allowed mismatches')
        if help:
            outfunc(helpinfo.format(student_file_path,mars_file_path))
        return False
    else:
        outfunc(f'You have reached the maximum mismatches ({cur_mismatches})')
        if help:
            outfunc(helpinfo.format(student_file_path,mars_file_path))
        return False




helpinfo = '''
Helpful resources for Debugging:
{} : output from the VHDL testbench during program execution on your processor
{} : output from MARS containing expected output
vsim.wlf: waveform file generated by processor simulation, you can display this simulation in ModelSim without resimulating your processor by hand

'''

if __name__ == '__main__':
    main()
    
#mars output regexs
#r'\[inst #(?P<num>[0-9]+)\] (?P<instr>[0-9$a-z ,\-\(\)]+)'
#r'Register Write to Reg: (?P<reg>[0-9A-Fa-fx]+) Val: (?P<val>[0-9xA-Fa-f]+)'
#r'Memory Write to Addr: (?P<addr>[0-9A-Fa-fx]+) Val: (?P<val>[0-9xA-Fa-f]+)'

#student testbench output regexs
#r'In clock cycle: (?P<cycle>[0-9]+)'
#r'Register Write to Reg: (?P<reg>[0-9A-Fa-fx]+) Val: (?P<val>[0-9xA-Fa-f]+)'
#r'Memory Write to Addr: (?P<addr>[0-9A-Fa-fx]+) Val: (?P<val>[0-9xA-Fa-f]+)'
