import tkinter as tk
import os
import test_framework

#Path to the mips folder
mipsFolder = r'mips'

allSelected = False

def guiMain():

    window = tk.Tk()
    window.title("Testing Framework")
    window.configure(bg="gray60")

    fileSelectFrame = tk.Frame(bg="gray60",master=window)

    menuItems = tk.Frame(bg="gray60",master=window)

    secondMenuItems = tk.Frame(bg="gray60",master=window)

    thirdMenuItems = tk.Frame(bg="gray60",master=window)

    
    #This Makes a button
    runButton = tk.Button(menuItems, bg="green3", text="Run", width=25, command=chooseSelectedFiles)

    runButton.pack(side=tk.LEFT)


    #This Makes a button
    exitButton = tk.Button(menuItems, bg="firebrick3", text="Exit", width=25, command=window.destroy)

    exitButton.pack(side=tk.LEFT)



    #This makes the Compile Button
    global compileASM
    compileASM=tk.IntVar()
    tk.Checkbutton(
            secondMenuItems,
            text="Compile?",
            variable=compileASM,
            onvalue=1,
            offvalue=0,
            bg="gray60"
            ).pack(side=tk.LEFT, anchor=tk.W)

    compileASM.set(1)

    #Adds padding
    tk.Label(
        secondMenuItems,
        text = " ",
        bg="gray60"
    ).pack(side=tk.LEFT, anchor=tk.W)

    #Adds the timeout selector
    defaultTimeout = tk.IntVar()
    defaultTimeout.set(30)
    global timeout
    timeout= tk.Spinbox(
            secondMenuItems,
            text="Timeout",
            from_=0,
            to =100,
            bg="gray60",
            width = 10,
            wrap = "true",
            textvariable=defaultTimeout
            )
    timeout.pack(side=tk.LEFT, anchor=tk.W)
    tk.Label(
        secondMenuItems,
        text="Timeout",
        bg="gray60"
    ).pack(side=tk.LEFT, anchor=tk.W)

    #Adds padding
    tk.Label(
        secondMenuItems,
        text = " ",
        bg="gray60"
    ).pack(side=tk.LEFT, anchor=tk.W)

    #Adds the max error selector
    defaultMaxErrors = tk.IntVar()
    defaultMaxErrors.set(3)
    global maxErrors
    maxErrors= tk.Spinbox(
            secondMenuItems,
            text="MaxErrors",
            from_=0,
            to =100,
            bg="gray60",
            width = 10,
            wrap = "true",
            textvariable=defaultMaxErrors
            )
    maxErrors.pack(side=tk.LEFT, anchor=tk.W)

    tk.Label(
        secondMenuItems,
        text="Max Errors",
        bg="gray60"
    ).pack(side=tk.LEFT, anchor=tk.W)





    global justFiles
    justFiles = []

    #Get all the files and folders in the mips subdirectory.
    allFiles = os.listdir(mipsFolder)

    #This loop adds only the files to justFiles array and ignores the subdirectories
    for x in allFiles:
        if os.path.isfile(os.path.join(mipsFolder,x)):
            justFiles.append(x)


    #This adds the Checkboxes for each file
    global var
    var = []
    for x in justFiles:
        var.append(tk.IntVar())
        tk.Checkbutton(
            fileSelectFrame,
            text=x,
            variable=var[-1],
            onvalue=1,
            offvalue=0,
            bg="gray60"
            ).pack(anchor=tk.W)



    #This Makes a button
    selectAll = tk.Button(thirdMenuItems, bg="gray64", text="Select All", width=25, command=selectAllFiles)

    selectAll.pack(side=tk.LEFT)



    #This packs the menu and check boxes
    secondMenuItems.pack()
    menuItems.pack()
    fileSelectFrame.pack()
    thirdMenuItems.pack()


    #This is the main loop for the window
    window.mainloop()


def selectAllFiles():

    global allSelected

    if(allSelected):
        for x in range(0, len(var)):
            var[x].set(0)
        allSelected = False

    else:
        for x in range(0, len(var)):
            var[x].set(1)
        allSelected = True


    


#This method is run when the "Run" button is pressed
#It queues all the assembly files selected to run.
def chooseSelectedFiles():
    asm_files_to_run = []
    for x in range(0, len(var)):
        if var[x].get() == 1:
            asm_files_to_run.append(os.path.join(mipsFolder,justFiles[x]))


    options = {
        'sim-timeout':int(timeout.get()),
        'max-mismatches':int(maxErrors.get())
    }


    if compileASM.get() == 1:
        options['compile'] = True
    else:
        options['compile'] = False

    test_framework.queueSimulation(asm_files_to_run, options)
