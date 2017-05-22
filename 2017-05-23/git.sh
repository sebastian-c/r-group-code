# copy files

git init .

# Look at .gitignore

git commit -am "Initial commit"

echo "There are 9 planets in the solar system" > planets.txt
git add planets.txt
git commit -m "Stated number of planets"

echo "There are 8 planets in the solar system" > planets.txt
git add planets.txt
git commit -m "Reduced number of planets to 8. Pluto isn't a planet"

git checkout -b star-test

echo "There is a single star in our solar system" > stars.txt
git add stars.txt
git commit -m "Stated number of stars"

git checkout master
echo "There is also 1 dwarf planet in the solar system" >> planets.txt
git add planets.txt
git commit -m "Compromised on the status of Pluto"

git merge star-test

# Sometimes there are conflicts

git checkout -b rethinking-planets
echo "There are 9 planets in the solar system" > planets.txt
git add planets.txt
git commit -m "Changed my mind - Pluto is definitely a planet"

git checkout master
sed -i '2 d' planets.txt 
echo "There is also 1 dwarf planet in the solar system named Pluto" >> planets.txt
git add planets.txt
git commit -m "Named the dwarf planet Pluto"

git merge rethinking-planets

# Clone a project
cd ..
git clone git@github.com:sebastian-c/r-group-code.git
