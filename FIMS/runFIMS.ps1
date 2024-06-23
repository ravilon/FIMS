# Get the directory of the current script
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Define virtual environment directory and activate script path
$venvDir = Join-Path -Path $scriptDir -ChildPath "myenv"
$activateScript = Join-Path -Path $venvDir -ChildPath "Scripts\Activate.ps1"

# Function to create virtual environment and install dependencies
function CreateVirtualEnvironment {
    Write-Output "Creating virtual environment in '$venvDir'..."
    python -m venv $venvDir
    if (Test-Path -Path $activateScript -PathType Leaf) {
        Write-Output "Activating virtual environment..."
        & $activateScript
        # Install dependencies from requirements.txt
        if (Test-Path -Path (Join-Path -Path $scriptDir -ChildPath "requirements.txt") -PathType Leaf) {
            Write-Output "Installing dependencies from requirements.txt..."
            pip install -r (Join-Path -Path $scriptDir -ChildPath "requirements.txt")
        } else {
            Write-Warning "requirements.txt not found in '$scriptDir'. Please provide the requirements file."
        }
    } else {
        Write-Warning "Activate script not found in '$activateScript'. Please ensure the virtual environment is set up correctly."
    }
}

# Check if 'myenv' folder exists, create and activate if not
if (Test-Path -Path $venvDir -PathType Container) {
    Write-Output "Found virtual environment in '$venvDir'"
    
    # Activate the virtual environment
    if (Test-Path -Path $activateScript -PathType Leaf) {
        Write-Output "Activating virtual environment..."
        & $activateScript
    } else {
        Write-Warning "Activate script not found in '$activateScript'. Please ensure the virtual environment is set up correctly."
    }
} else {
    CreateVirtualEnvironment
}

# Set the FLASK_APP environment variable
$env:FLASK_APP = "app.py"

# Set the FLASK_ENV environment variable
$env:FLASK_ENV = "development"

# Navigate to the 'app' directory which is assumed to be a subdirectory of the script's location
Set-Location -Path (Join-Path -Path $scriptDir -ChildPath "app")

# Run the Flask application
flask run
