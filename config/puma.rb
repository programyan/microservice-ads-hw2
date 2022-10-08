port ENV.fetch('PORT', 9293)
environment ENV.fetch('RACK_ENV', 'development')
pidfile ENV.fetch('PIDFILE', 'tmp/pids/server.pid')

preload_app!
