class opkeystone {
 
   exec{ 'update':
      command => 'apt-key update; apt-get update',
 }
}
