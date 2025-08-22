
sed -i '/int Guess/a \
  int   j = 0;\
  char* jobs = getenv( "NINJAJOBS" );\
  if ( jobs != NULL ) j = atoi( jobs );\
  if ( j > 0 ) return j;\
' src/ninja.cc

python3 configure.py --bootstrap --verbose

mkdir -p $PCKDIR/usr/bin
install -vm755 ninja $PCKDIR/usr/bin/
install -vDm644 misc/bash-completion $PCKDIR/usr/share/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion  $PCKDIR/usr/share/zsh/site-functions/_ninja
