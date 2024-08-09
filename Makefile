.PHONY: build docs test deploy
# Variables for server settings
PORT = 8000
LOG_FILE = server_log.txt
ERROR_LOG_FILE = server_error_log.txt

build:
	@echo "Building the project..."
	# Add other build steps if necessary
	@powershell -Command "Write-Output 'Build process completed.' | Out-File -Append build_log.txt"

docs:
	@echo "Generating documentation..."
	@python src/generate_docs.py
	@powershell -Command "Write-Output 'Documentation generated successfully.' | Out-File -Append docs_log.txt"
	@powershell -Command "Get-Content docs_log.txt"

	@echo "Generating html..."
	@cd docs && make html
	@powershell -Command "Write-Output 'Documentation generated successfully.' | Out-File -Append docs_log.txt"
	@powershell -Command "Get-Content docs_log.txt"

test:
	@echo "Running tests..."
	pytest tests
	
deploy:
	@echo Deploying the project... > deploy_log.txt
	@echo Testing xcopy >> deploy_log.txt
	@powershell -Command "xcopy /E /I /Y src\* C:\Users\luism\Documents\projectdeploy\ >> deploy_log.txt 2>&1"
	@echo Directory contents: >> deploy_log.txt
	@powershell -Command "Get-ChildItem C:\Users\luism\Documents\projectdeploy | Out-File -Append deploy_log.txt -Encoding utf8"
	@powershell -Command "Get-Content deploy_log.txt -Encoding utf8"

serve:
	@echo "Starting HTTP server on port $(PORT)..."
	@powershell -Command "Start-Process python -ArgumentList '-m http.server $(PORT) --directory docs' -NoNewWindow -RedirectStandardOutput $(LOG_FILE) -RedirectStandardError $(ERROR_LOG_FILE)"
	@powershell -Command "Start-Sleep -Seconds 5"
	@powershell -Command "Write-Output 'Server started on port $(PORT).' | Out-File -Append $(LOG_FILE)"
	@powershell -Command "Get-Content $(LOG_FILE)"