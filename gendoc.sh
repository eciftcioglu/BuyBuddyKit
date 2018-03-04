#!/bin/sh

echo 'generating docs for BuyBuddyKit'

jazzy \
  --objc \
  --clean \
  --author BuyBuddy \
  --author_url http://dev.buybuddy.co \
  --github_url https://github.com/heybuybuddy/BuyBuddy.app \
  --github-file-prefix https://github.com/heybuybuddy/BuyBuddy.app/tree/2.0.0 \
  --module-version 2.0.0 \
  --module BuyBuddy \
  --theme fullwidth \
  --documentation=Documentation/Guides/*.md \
  --abstract=Documentation/Sections/*.md \
  --output=Documentation/_build


