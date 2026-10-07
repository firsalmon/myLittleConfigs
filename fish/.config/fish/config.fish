pokego -r 5 --no-title

if status is-interactive
    # Commands to run in interactive sessions can go here
end

function clear
  command clear
  pokego -r 5 --no-title
end

function clr
  command clear
end
