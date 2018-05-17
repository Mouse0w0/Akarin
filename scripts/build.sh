#!/usr/bin/env bash

(
set -e
basedir="$(cd "$1" && pwd -P)"
workdir="$basedir/work"
paperbasedir="$basedir/work/Paper"
paperworkdir="$basedir/work/Paper/work"

if [ "$2" == "--setup" ] || [ "$3" == "--setup" ] || [ "$4" == "--setup" ]; then
	echo "[Akarin] Setup Paper.."
	(
		if [ "$2" == "--remote" ] || [ "$3" == "--remote" ] || [ "$4" == "--remote" ]; then
			cd "$paperworkdir"
			git clone https://github.com/Akarin-project/Minecraft.git
		fi
		
		cd "$paperbasedir"
		./paper jar
	)
fi

echo "[Akarin] Ready to build"
(
	echo "[Akarin] Touch sources.."
	yes|cp -rf "$basedir/sources/server/src" "$paperbasedir/Paper-Server/"
	yes|cp -rf "$basedir/sources/server/pom.xml" "$paperbasedir/Paper-Server/"
	
	cd "$paperbasedir"
	if [ "$2" == "--fast" ] || [ "$3" == "--fast" ] || [ "$4" == "--fast" ]; then
		echo "[Akarin] Test has been skipped"
		mvn clean install -DskipTests
	else 
		mvn clean install
	fi
	
	minecraftversion=$(cat "$paperworkdir/BuildData/info.json"  | grep minecraftVersion | cut -d '"' -f 4)
	rawjar="$paperbasedir/Paper-Server/target/paper-$minecraftversion.jar"
	yes|cp -rf "$rawjar" "$basedir/akarin-$minecraftversion.jar"
	
	echo ""
	echo "[Akarin] Build successful"
	echo "[Akarin] Migrated final jar to $basedir/akarin-$minecraftversion.jar"
)

)