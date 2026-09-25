# lidon

Close your MacBook lid and keep it running, on battery, without an external display. Wi-Fi stays connected.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/yungweng/lidon/main/install.sh | sh
```

Works with fish, bash and zsh.

## Use

```sh
lidon    # Mac stays awake when the lid is closed
lidoff   # back to normal sleep
```

Check the state with `pmset -g | grep SleepDisabled` (`1` = stays awake).

## Notes

- Uses `sudo pmset -a disablesleep`, so you'll be asked for your password.
- The setting stays active until you run `lidoff` or reboot.
- Don't put the closed Mac in a bag while `lidon` is active. It can get hot.

## Uninstall

```sh
lidoff
rm -f ~/.lidon.sh ~/.config/fish/functions/lidon.fish ~/.config/fish/functions/lidoff.fish
```

Then remove the `.lidon.sh` line from `~/.bashrc`, `~/.bash_profile` or `~/.zshrc`.

## License

MIT
