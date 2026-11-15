if status is-interactive
	# Commands to run in interactive sessions can go here

	# Remove fish greeting
	set -U fish_greeting

	# Run fastfetch configuration on shell startup
	fastfetch -c /etc/fastfetch/term.jsonc
end

starship init fish | source
