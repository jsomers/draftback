# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_draftotron_session',
  :secret      => 'e04f1ebfe88988c09386564ae3dcb3f50e5967e8aa3fe2f5ef27f64f5bd17aaa41a4626e8fe121dffdea408d4639bec9a47a257d95b96b5592f0cfe041b41426'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
