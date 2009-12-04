## Special steps to get this running

1. Drop the production.sqlite3 database into the /home/james/public_html/draftback/shared/ directory.
2. Add `ENV["JAVA_HOME"] = "/usr/lib/jvm/java-6-openjdk"` to **environment.rb**. This is of course after installing that Open JDK software (which may be unnecessary...)
3. Install both the stanford parser gem *and* the actual software.