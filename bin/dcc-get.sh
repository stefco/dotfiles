#!/bin/ksh
#
# Name: dcc-get.sh
#
# Wrapper around the kinit powered, IDP selection avoiding, curl command
#
# Example:
#
#          ./dcc-get.sh S1103945 pdf
#
#          Will retrieve the pdf file from document S1103945 into
#          a file named S1103945.pdf
#
#          ./dcc-get.sh S1103945 of=xml
#
#          Will retrieve an XML dump of the document page.
#

document="$1"
format="$2"

curltest=$(curl -V)
if [[ ! "$curltest" =~ (GSS-API|GSS-Negotiate) ]]
then
   print "Your version of 'curl' does not support GSS-Negotiate (for Kerberos support). Sorry!"
   exit
fi

if [[ ${#document} -eq 0 ]]
then
   print "Required argument 'document' (i.e.: X1234567 or X1234567-v8)  missing"
   exit
fi

if [[ ! "$document" =~ ^[A-Z]\d{6,8}(-v\d+)?$ ]]
then
   print "Malformed document spec. Must be like X1234567 or X1234567-v12"
   exit
fi

test=$(klist -s 2>&1)

if [[ $? > 0 ]]
then
   print "No valid Kerberos session. You must run kinit"
   exit
fi

if [[ ${#format} -eq 0 ]]
then
   format=pdf
fi

if [[ ! "$format" =~ ^(of=xml|[a-zA-Z0-9]+)$ ]]
then
   print "Malformed format spec. Must be like pdf, txt, doc, etc. or of=xml"
   exit
fi

if [[ "$format" =~ of\=xml ]]
then
   ext='xml'
else
   ext="$format"
fi

command="curl --silent -o ${document}.${ext} --insecure --negotiate -c /tmp/curl-cookies -b curl-cookies --user : --location-trusted https://dcc.ligo.org/Shibboleth.sso/Login?target=https%3A%2F%2Fdcc.ligo.org%2F${document}%2F${format}&entityID=https%3A%2F%2Flogin2.ligo.org%2Fidp%2Fshibboleth"

$command
