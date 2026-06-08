#!/usr/bin/env python3
import http.server
import socketserver
import getpass
import shutil
import subprocess
import sys
from io import BytesIO
from string import Template

LISTEN_ADDR = '0.0.0.0'
LISTEN_PORT = 8000
KICKSTART_FILE = 'workstation.ks'
FEDORA_CONTAINER_IMAGE = 'registry.fedoraproject.org/fedora:44'

def run_container_mkpasswd():
  if not shutil.which('podman'):
    print('mkpasswd was not found and podman is not installed.')
    sys.exit(1)

  password = getpass.getpass('Password: ')
  if not password:
    print('You must enter a user password.')
    sys.exit(1)

  return subprocess.run([
    'podman',
    'run',
    '--rm',
    '-i',
    '--pull=missing',
    FEDORA_CONTAINER_IMAGE,
    'sh',
    '-c',
    'dnf -y -q install mkpasswd >/dev/null && exec mkpasswd --stdin',
  ], input=password + '\n', capture_output=True, text=True)

def run_mkpasswd():
  if shutil.which('mkpasswd'):
    return subprocess.run(['mkpasswd'], capture_output=True, text=True)
  return run_container_mkpasswd()

class KickstartHandler(http.server.SimpleHTTPRequestHandler):
  def send_head(self):
    if self.translate_path(self.path).endswith('/%s' % KICKSTART_FILE):
      self.send_response(200)
      self.send_header('Content-type', 'text/html; charset=ascii')
      self.send_header('Content-Length', str(len(body)))
      self.end_headers()
      return BytesIO(body.encode('ascii'))
    else:
      self.send_response(404)
      self.end_headers()

userpass_input = run_mkpasswd()
if userpass_input.returncode != 0:
  print('Could not generate user password hash.')
  if userpass_input.stderr:
    print(userpass_input.stderr.rstrip('\n'))
  exit(1)
if not userpass_input or not userpass_input.stdout:
  print('You must enter a user password.')
  exit(1)

userpass = userpass_input.stdout.rstrip('\n')

with open(KICKSTART_FILE, 'r') as f:
  t = Template(f.read())
  body = t.safe_substitute(userpass=userpass)

with socketserver.TCPServer((LISTEN_ADDR, LISTEN_PORT), KickstartHandler) as httpd:
  print('Serving kickstart file on http://%s:%d.' % (LISTEN_ADDR, LISTEN_PORT))
  try:
    httpd.serve_forever()
  except KeyboardInterrupt:
    print('Exiting.')
    exit(0)
