# binlock
binlock: A tool of file-encryption

# Get binlock

  git clone -b binlock-{version} https://SeaflyDennis@github.com/SeaflyDennis/binlock
- Example:
  git clone -b binlock-v2 https://SeaflyDennis@github.com/SeaflyDennis/binlock
  git clone -b binlock-v5 https://SeaflyDennis@github.com/SeaflyDennis/binlock

# Install binlock

  cd binlock/
  make && make install

# Run binlock

- For binlock-v2

  $ blv2
  $ blv2 <src_file> <password> <id>
  $ ublv2
  $ ublv2 <dst_file>
  
- For binlock-v5

  $ blv5

# Introduction of binlock version

## binlock-v2

- Encryption range: All files of non-text or non-ascii
- Encryption Way: password + ID
- Deciphering Way: Verify password at first, verify ID if incorrected-password.
- Version's Features: high speed.

## binlock-v5

- Encryption range: All files, include text files or ascii files.
- Encryption Way: username + password + ID
- Deciphering Way: Verify password under the specific username at first, verify ID if incorrected-password.
- Version's Features: high speed, support multi-users encrypt the file.

# Branch & Version

- Note: If you encrypt file with a specific version of binlock, you must deciphering with the same version as before!
