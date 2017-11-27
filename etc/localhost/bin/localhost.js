#! /usr/bin/env node
var args        = require('yargs').argv,
    fs          = require('fs'),
    local       = require('../');


if(args.h || args.help){
    return fs.createReadStream(__dirname + '/help.txt')
        .pipe(process.stdout)
        .on('close', function(){
            process.exit(1);
        });
}

if(!args._.length){
    console.log(local.toggle());
    process.exit();
}

if(args._[0] == 'list'){
    console.log(local.list());
    process.exit();
}

if(args._[0] == 'add'){
    var domain, ip;
    domain = args.domain || args.d || false;
    ip = args.ip || args.i || '127.0.0.1';

    if(!domain){
        console.log('Error: you must specify domain. see --help for more detail.');
        process.exit();
    }

    console.log(local.add(domain, ip));
    process.exit();
}

if(args._[0] == 'remove'){
    var domain;
    domain = args.domain || args.d || false;

    if(!domain){
        console.log('Error: you must specify domain. see --help for more detail.');
        process.exit();
    }

    console.log(local.remove(domain));
    process.exit();
}

if(args._[0] == 'stop'){
    console.log(local.disable());
    process.exit();
}


if(args._[0] == 'start'){
    console.log(local.enable());
    process.exit();
}

if(args._[0] == 'status'){
    var status = local.status();
    if(status.total==0){
        console.log('No entrees are found in hosts file.');
    }
    else if(status.total==status.disabled){
        console.log('Local hosts is currently disabled.');
    }
    else if(status.disabled==0){
        console.log('Local hosts is currently enabled.');
    }
    else {
        console.log('Local hosts is partially disabled.');
    }
    process.exit();
}

