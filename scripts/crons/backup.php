<?php
// set timezone
date_default_timezone_set('America/New_York');


// read config
$backups = json_decode(file_get_contents(dirname(__DIR__ ) . '/config/cron/backups.json'));


// start sql
system('rm -rf ~/.my.cnf;cp '.__DIR__.'/.my.cnf ~/;chmod 0600 ~/.my.cnf');





foreach($backups as $project){

    // Backup
    $today = date('Ymd');
    $backupDir =  $project->backup . '/' . $today;

    // Create DIR
    if(!is_dir($backupDir)){
        system('mkdir -p ' . $backupDir);
    }

    // Backup DB
    system('mysqldump ' . $project->db . ' > ' . $backupDir . '/db.sql' );


    // Backup Files
    system('cd ' . $project->dir . ';' . 'tar -czf backup.tar.gz ./;mv backup.tar.gz ' . $backupDir . '/backup.tar.gz' );


    /*for($i=0; $i<1000; $i++){
        mkdir($project->backup . '/' . date('Ymd', strtotime('-'.$i.' days')));
    }*/




    foreach(glob($project->backup . '/*') as $dir){
        if(preg_match('#/([\d]{8})$#', $dir, $match)){
            $date = strtotime($match[1].' 00:00:00');
            $save = false;

            // 7 Days ago
            $sevenDaysAgo = strtotime(date('Y-m-d 00:00:00', strtotime('-7 days')));

            if($date > $sevenDaysAgo){
                $save = true;
            }


            // save 5 weeks from today
            if(!$save){
                for($i=0; $i<5; $i++){
                    $d = $i*7 + (int)date('w');
                    $sunday = strtotime(date('Y-m-d 00:00:00', strtotime('-'.$d.' days')));


                    if($sunday == $date){
                        $save = true;
                    }
                }
            }

            // Older than 5 weeks, save monthly
            if(!$save){
                $y = date('Y');
                if($y == date('Y', $date)){
                    for($i=1; $i<=12; $i++){
                        $monthly = strtotime(date('Y-m-d 00:00:00', strtotime($y.'-'.$i.'-01')));
                        if($monthly == $date){
                            $save = true;
                        }
                    }
                }
            }

            // then save yearly
            if(!$save){
                if(date('m', $date)=='12' && date('d', $date)=='31'){
                    $save = true;
                }
            }


            // Delete
            if(!$save){
                system('rm -rf ' . $dir);
            }

        }


    };




}


// end sql
system('rm -rf ~/.my.cnf');

