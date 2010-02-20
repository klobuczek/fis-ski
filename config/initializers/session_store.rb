# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_fis-ski_session',
  :secret      => '9750fd07dae61a0d18452486c3e02953dfd8482356dfc6d73c936d5846ce508eb4949f6b217ed0000f3999f73576526971621e22425bda018ac6598482b3ad4d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
