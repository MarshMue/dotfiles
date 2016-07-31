
#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
	DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
	SOURCE="$(readlink "$SOURCE")"
	[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

if [ -L $HOME/.vim ]; then
	echo "symlink exists for .vim"
else
	echo "Nuking .vim"
	rm -rf $HOME/.vim
	ln -s "$DIR" "$HOME"/.vim
fi

if [ -L $HOME/.vimrc ]; then
	echo "symlink exists for .vimrc"
else
	echo "Nuking .vimrc"
	rm $HOME/.vimrc
	ln -s "$DIR"/.vimrc "$HOME/.vimrc"
fi

git submodule update --init --recursive
vim +PluginInstall +qall
python ~/.vim/bundle/YouCompleteMe/install.py --gocode-completer
