# Ansible Code Review Reference

## Priority Focus
- Idempotency
- Secret handling
- Role structure and reusability
- Performance

## Idempotency

### Every Task Must Be Idempotent
```yaml
# BAD: Not idempotent - always runs
- name: Add user to group
  command: usermod -aG docker {{ user }}

# GOOD: Idempotent - only changes when needed
- name: Add user to docker group
  user:
    name: "{{ user }}"
    groups: docker
    append: yes

# BAD: Shell commands without creates/removes
- name: Download file
  shell: wget https://example.com/file.tar.gz

# GOOD: With idempotency guard
- name: Download file
  get_url:
    url: https://example.com/file.tar.gz
    dest: /tmp/file.tar.gz
    mode: '0644'
```

### Use Native Modules Over Shell/Command
```yaml
# Flag: command/shell when module exists
- command: apt-get install nginx  # BAD
- apt:                            # GOOD
    name: nginx
    state: present

- command: systemctl enable nginx  # BAD
- systemd:                         # GOOD
    name: nginx
    enabled: yes
    state: started

- shell: cp /src /dest            # BAD
- copy:                           # GOOD
    src: /src
    dest: /dest
```

### When command/shell Is Necessary
```yaml
# Provide creates/removes for idempotency
- name: Run one-time setup
  command: /opt/setup.sh
  args:
    creates: /opt/.setup-complete

# Use changed_when for accurate reporting
- name: Check status
  command: /opt/check-status.sh
  register: status
  changed_when: false  # Read-only operation

- name: Apply changes
  command: /opt/apply.sh
  register: result
  changed_when: "'Changes applied' in result.stdout"
```

## Secret Handling

### Never Hardcode Secrets
```yaml
# BAD: Secret in playbook
- name: Configure database
  template:
    src: db.conf.j2
    dest: /etc/db.conf
  vars:
    db_password: "supersecret123"  # NEVER!

# GOOD: Use ansible-vault
ansible-vault encrypt_string 'supersecret123' --name 'db_password'

# GOOD: Use environment variables
db_password: "{{ lookup('env', 'DB_PASSWORD') }}"

# GOOD: Use vault file
# In group_vars/all/vault.yml (encrypted)
vault_db_password: "supersecret123"

# In group_vars/all/vars.yml
db_password: "{{ vault_db_password }}"
```

### Protect Sensitive Output
```yaml
- name: Set password
  user:
    name: admin
    password: "{{ admin_password | password_hash('sha512') }}"
  no_log: true  # Prevents logging sensitive data

# Flag: Missing no_log on sensitive tasks
```

## Role Structure

### Standard Layout
```
roles/
└── webserver/
    ├── defaults/
    │   └── main.yml      # Default variables (lowest priority)
    ├── vars/
    │   └── main.yml      # Role variables (high priority)
    ├── tasks/
    │   └── main.yml      # Task entry point
    ├── handlers/
    │   └── main.yml      # Handlers (notify targets)
    ├── templates/
    │   └── config.j2     # Jinja2 templates
    ├── files/
    │   └── static.conf   # Static files
    ├── meta/
    │   └── main.yml      # Role metadata, dependencies
    └── molecule/         # Testing
        └── default/
```

### Role Best Practices
```yaml
# defaults/main.yml - Document all variables
---
# Port for the web server to listen on
webserver_port: 80

# Whether to enable HTTPS
webserver_https_enabled: false

# tasks/main.yml - Include sub-tasks
---
- name: Include OS-specific variables
  include_vars: "{{ ansible_os_family }}.yml"

- name: Include installation tasks
  include_tasks: install.yml

- name: Include configuration tasks
  include_tasks: configure.yml
```

### Handler Patterns
```yaml
# handlers/main.yml
- name: Restart nginx
  systemd:
    name: nginx
    state: restarted
  listen: "restart web server"

# In tasks - use handler names
- name: Update nginx config
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: restart web server
```

## Performance

### Reduce SSH Connections
```yaml
# Use pipelining
# ansible.cfg
[defaults]
pipelining = True

# Gather only needed facts
- hosts: all
  gather_facts: no  # Or use gather_subset

- hosts: all
  gather_facts: yes
  gather_subset:
    - network
    - hardware
```

### Efficient Loops
```yaml
# BAD: Multiple package tasks
- apt: name=nginx state=present
- apt: name=postgresql state=present
- apt: name=redis state=present

# GOOD: Single task with list
- name: Install packages
  apt:
    name:
      - nginx
      - postgresql
      - redis
    state: present

# Use async for long-running independent tasks
- name: Run long task
  command: /opt/long-running.sh
  async: 3600
  poll: 0
  register: async_task
```

### Limit Scope
```yaml
# Use --limit for targeted runs
# ansible-playbook site.yml --limit webservers

# Use tags
- name: Configure nginx
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  tags:
    - nginx
    - config
```

## Common Pitfalls

### Variable Precedence Issues
```yaml
# Flag: Overriding role defaults incorrectly
# Role defaults are lowest priority - easily overridden
# vars/ in role has higher priority than inventory

# Use set_fact sparingly - it has high priority
- set_fact:
    my_var: value  # Careful: overrides most other definitions
```

### Boolean Handling
```yaml
# GOOD: Explicit boolean values
enabled: true
disabled: false

# BAD: String "booleans"
enabled: "yes"   # Actually a string!
enabled: "True"  # Also a string!

# In conditionals
when: my_var | bool  # Explicit conversion
when: my_var == true  # Comparison to true
```

### Template Safety
```yaml
# Flag: Missing | default filter
"{{ undefined_var }}"  # Error if undefined!

# GOOD: Provide defaults
"{{ my_var | default('fallback') }}"
"{{ my_list | default([]) }}"

# Flag: Unquoted variables in YAML
key: {{ value }}   # BAD: YAML parsing issue

# GOOD: Quote variables
key: "{{ value }}"
```

## Security Checks

- Secrets in plain text
- Missing `no_log: true` on sensitive tasks
- World-readable file permissions on sensitive files
- Running as root when not necessary
- Missing `become: yes` when needed
- Exposed ports without firewall rules

## Documentation Standards

```yaml
---
# Role: webserver
# Description: Install and configure nginx web server
# Requirements:
#   - Ansible 2.9+
#   - Target: Ubuntu 20.04+
#
# Variables:
#   webserver_port: Port to listen on (default: 80)
#   webserver_root: Document root (default: /var/www/html)
#
# Example:
#   roles:
#     - role: webserver
#       webserver_port: 8080

- name: Install nginx
  apt:
    name: nginx
    state: present
```

## Testing with Molecule

```yaml
# molecule/default/molecule.yml
---
dependency:
  name: galaxy
driver:
  name: docker
platforms:
  - name: instance
    image: ubuntu:22.04
provisioner:
  name: ansible
verifier:
  name: ansible

# molecule/default/verify.yml
---
- name: Verify
  hosts: all
  tasks:
    - name: Check nginx is running
      service:
        name: nginx
        state: started
      check_mode: yes
      register: result
      failed_when: result.changed
```
