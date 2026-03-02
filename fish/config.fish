set -g fish_greeting

pokego --nt -s -r 1,1,1

if status is-interactive
    # Commands to run in interactive sessions can go here
end

function clear
  command clear
  pokego --nt -s -r 1,1,1
end

function clr
  command clear
end
