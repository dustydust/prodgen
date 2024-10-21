#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Name of the virtual environment folder
VENV_DIR="venv"

# Function to create and activate virtual environment
prepare_venv() {
    echo "Creating virtual environment..."
    python3 -m venv $VENV_DIR

    echo "Activating virtual environment..."
    source $VENV_DIR/bin/activate

    echo "Installing dependencies..."
    pip install --upgrade pip
    pip install -r requirements.txt

    echo "Virtual environment setup completed."
}

# Check if the virtual environment directory exists
if [ -d "$VENV_DIR" ]; then
    echo "Virtual environment already exists. Activating..."
    source $VENV_DIR/bin/activate
else
    # Create and activate the virtual environment if it doesn't exist
    prepare_venv
fi

echo "To activate the virtual environment, run: source $VENV_DIR/bin/activate"
