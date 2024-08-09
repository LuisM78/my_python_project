import paramiko
import time
import logging
import os

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Server credentials from environment variables
server_ip = os.getenv('SERVER_IP', '192.168.0.110')
username = os.getenv('SSH_USERNAME', 'luism')
key_file = os.getenv('SSH_KEY_FILE', 'C:\\Users\\luism\\.ssh\\id_rsa')
project_dir = 'C:\\Users\\luism\\Documents\\my_python_project'

# Commands to run on the server
commands = [
    f'cd {project_dir} && git pull origin main',
    f'cd {project_dir} && make build',
    f'cd {project_dir} && make docs',
    f'cd {project_dir} && make test',
    f'cd {project_dir} && make deploy',
    f'cd {project_dir} && make serve'
]


def run_commands_on_server(commands):
    try:
        # Create an SSH client
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        client.connect(server_ip, username=username, key_filename=key_file)

        for command in commands:
            logging.info(f'Running command: {command}')
            stdin, stdout, stderr = client.exec_command(command)
            exit_status = stdout.channel.recv_exit_status()
            if exit_status == 0:
                logging.info(f'Success: {command}')
                logging.info(stdout.read().decode())
            else:
                logging.error(f'Error: {command}')
                logging.error(stderr.read().decode())
                break

    except paramiko.SSHException as e:
        logging.error(f'SSH Error: {e}')
    except Exception as e:
        logging.error(f'Error: {e}')
    finally:
        client.close()

def check_for_new_commits():
    # Placeholder function: Implement actual logic to check for new commits
    return True

if __name__ == "__main__":
    while True:
        if check_for_new_commits():
            run_commands_on_server(commands)
        
        time.sleep(90)  # Check every minute
