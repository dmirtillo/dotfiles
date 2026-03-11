if isdirectory('/opt/homebrew/opt/fzf')
  set rtp+=/opt/homebrew/opt/fzf
elseif isdirectory('/usr/share/fzf')
  set rtp+=/usr/share/fzf
endif