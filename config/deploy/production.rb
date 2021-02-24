# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

server "128.199.245.250", user: "deployer", roles: %w{app db web}, primary: true
set :rails_env, :production

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
set :ssh_options, {
  keys: %w(~/.ssh/id_rsa),
  forward_agent: true,
  auth_methods: %w(publickey password),
  port: 2234
}
task :test do
  puts 'start'
  puts Figaro.env.smtp_username
  puts 'end'
end

task :set_aciton_mailer_auth do
  put 'smtp_username: ' + ENV['SMTP_USERNAME'], 'qna/current/config/application.yml'
  put 'smtp_password: ' + ENV['SMTP_PASSWORD'], 'qna/current/config/application.yml'
end

before 'deploy:started', 'set_aciton_mailer_auth'