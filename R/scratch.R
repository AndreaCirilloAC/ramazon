key_pair_address <-  paste(cd,"/",key_pair_name,".pem", sep = "")
user_server      <-  paste("ubuntu@",Public_DNS, sep = "")

fileConn         <-  file("temporary.txt")
command          <-  paste("chmod 400 ",key_pair_address,sep = "")
command          <-  append(command,paste("ssh -o StrictHostKeyChecking=no -v -i ",key_pair_address, " ",user_server,sep = ""))
writeLines(command, fileConn)
close(fileConn)
