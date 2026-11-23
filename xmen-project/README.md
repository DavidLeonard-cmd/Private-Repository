# X-Men Team Roster Report

Author: David Leonard.

## Description

This script displays an X-Men roster and counts the team members.
The sample input file is xmen-roster.txt.
Each line contains one character and their powersets.

## How to run

Open an Ubuntu terminal in the project folder and run:

bash xmen-report.sh

The sample roster displays five characters and a total member count of 5.
To change the roster, edit xmen-roster.txt.
Use one character per line with no blank lines.
Press Enter after the final character (SUPER important; whitespace and TAB are NOT your friends!).

## How to build

Run:

make build

This creates xmen-package.zip containing the script, sample input,
and this README.

Extract the ZIP into a folder to use the packaged solution.
Open an Ubuntu terminal in that folder and run:

bash xmen-report.sh

## How to deploy

From the project folder inside the Git repository, run:

make deploy

This builds the ZIP and commits the project files and package.
Push the commit to share it through the online repository.

## Help

Run make or make help to display the build and deploy instructions.
