
let lines = Number(prompt('Number of branches'));
let max = 1 + 2*(lines - 1);


for (let i = 0; i < lines; i++) {
    let curr = i*2 + 1;
    let currLine = ' '.repeat((max-curr)/2) + '*'.repeat(curr) + ' '.repeat((max-curr)/2);
    console.log(currLine); 
}

for (let i = 0; i < 3; i++) {
    let currLine = ' '.repeat((max-3)/2) + '*'.repeat(3) + ' '.repeat((max-3)/2);  
    console.log(currLine);
}