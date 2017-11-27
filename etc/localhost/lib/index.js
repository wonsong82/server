// Load modules
var fs          = require('fs'),
    path        = require('path'),
    LineReader  = require('line-reader-sync');


module.exports = new Local();


function Local(){
    var _this = this;

    _this.hostsPath = 'C:/Windows/System32/drivers/etc/hosts';

    _this.startString = '# Local ENV: controlled by local node module';
    _this.endString   = '# Local ENV: end';
    _this.EOL         = "\r\n";


    _this.__construct = function(){

        if(!fs.existsSync(_this.hostsPath)){
            console.error('Error: inaccessable hosts file');
            process.exit();
        }
    }

    // add to hosts file
    _this.add = function(domain, ip){
        var list;

        list = getContents();
        if(findFromList(list.captured, domain) != -1){
            return 'Notice: Domain specified already exists in hosts file.';
        }

        list.captured.push(ip + "\t" + domain);
        writeToHosts(list);
        return 'Entry "' + ip + "\t" + domain + '" was added to hosts file.';
    }

    _this.remove = function(domain){
        var list, i, removed, rip, rdomain;

        list = getContents();
        if(-1 == (i = findFromList(list.captured, domain))){
            return 'Notice: Domain specified cannot be found.';
        }

        removed = list.captured.splice(i, 1);
        writeToHosts(list);

        removed = removed[0].split("\t");
        rip = removed[0];
        rdomain = removed[1];

        return 'Entry "' + rip + "\t" + domain + '" was removed from hosts file.';
    }

    _this.list = function(){
        var list;

        list = getContents();
        return list.captured.join("\r\n");

    }


    _this.disable = function(){
        var list, i, modded = [];

        list = getContents();
        for(i=0;i<list.captured.length;i++){
            if(list.captured[i].match(/^#/)){
                modded.push(list.captured[i]);
            }
            else {
                modded.push('#'+list.captured[i]);
            }
        }

        list.captured = modded;
        writeToHosts(list);

        return 'Local hosts disabled.';
    }

    _this.enable = function(){
        var list, i, modded = [];

        list = getContents();
        for(i=0;i<list.captured.length;i++){
            if(list.captured[i].match(/^#/)){
                modded.push(list.captured[i].replace(/^[# ]+/, ''));
            }
            else {
                modded.push(list.captured[i]);
            }
        }

        list.captured = modded;
        writeToHosts(list);

        return 'Local hosts enabled.';
    }

    _this.status = function(){
        var list, i, total, disabled = 0;

        list = getContents();
        total = list.captured.length;
        for(i=0;i<total;i++){
            if(list.captured[i].match(/^#/)){
                disabled++;
            }
        }

        return {
            total: total,
            disabled: disabled
        }
    }

    _this.toggle = function(){
        var status;

        status = _this.status();
        if(status.total==0){
            return 'No entrees to toggle.';
        }
        else if(status.disabled==0){
            return _this.disable();
        }
        else {
            return _this.enable();
        }

    }



    function findFromList(list, domain){
        var i;
        for(i=0;i<list.length;i++){
            if(list[i].indexOf(domain)!=-1){
                return i;
            }
        }
        return -1;
    }


    function getContents(){
        var reader, line, pre = [], captured = [], post = [], start, end;

        // read the hosts file
        reader = new LineReader(_this.hostsPath);
        while(null !== (line = reader.readline())){
            line = line.replace(/[\r\n]/,'');

            if(line.match(_this.startString)){
                start = true;
                continue;
            }
            if(line.match(_this.endString)){
                end = true;
                continue;
            }

            if(!start){
                pre.push(line);
            }
            else if(start && !end){
                captured.push(line);
            }
            else {
                post.push(line);
            }

        }

        // if there is no directives, add one
        if(!start || !end){
            captured = [];
            writeToHosts({pre, captured, post});
            return getContents();
        }

        return {
            pre: pre,
            captured: captured,
            post: post
        }
    }


    function writeToHosts(list){
        var contents, i, pre, captured, post;

        contents = list.pre;
        captured = list.captured;
        post = list.post;

        contents.push(_this.startString);
        for(i=0;i<captured.length;i++){
            contents.push(captured[i]);
        }
        contents.push(_this.endString);
        for(i=0;i<post.length;i++){
            contents.push(post[i]);
        }

        try{
            fs.writeFileSync(_this.hostsPath, contents.join(_this.EOL));
        }
        catch(e){
            if(e.code = 'EPERM'){
                console.log('Error: You need su or admin to perform.');
                process.exit();
            }
        }
    }




    _this.__construct();
}




