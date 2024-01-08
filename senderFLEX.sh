#!/bin/bash
echo "
Script de instalação ...

### <==========================================================================================> ###
### <===================== SENDERFLEX - CentOS 7 X64 ==============================> ###
### <==========================================================================================> ###

Aguarde, preparando a Instalação.. 
"
yum install net-tools -y >/dev/null 2>&1
ifconfig > /tmp/placarede.infoC
sed -i 's/:.*//' /tmp/placarede.info
sed -i '2,1000d' /tmp/placarede.info
placarede=$(cat /tmp/placarede.info)

if [ $(/usr/bin/getconf LONG_BIT) = 64 ] 
then 
    Release=$(grep -o 'release..' /etc/redhat-release | cut -d " " -f2)
    if [ $Release = 6 ] || [ $Release = 7 ] || [ $Release = 8 ]
    then
        echo "CentOS $Release X64 detectado ... "
        sleep 1
        echo "Você deseja configurar sua rede de ips adicionais antes de instalar o sistema? (sim|não) "
        read ConfigRede
        if [ $ConfigRede = "sim" ]
        then
            echo 'Detectando rede e comunicações ... '
            yum remove cloud-init -y >/dev/null 2>&1
            yum install vim -y >/dev/null 2>&1
            ls /etc/sysconfig/network-scripts | grep $placarede -q && Eth=$placarede || Eth=$placarede && ls /etc/sysconfig/network-scripts | grep $Eth\0 -q && Eth=$Eth\0 || Eth=$Eth\1 
            IpPrincipal0=$(ip a | grep 'inet ' | grep $Eth$ | awk '{print $2}' | cut -f1 -d/ | egrep -v "^127.[0-9]|^10.[0-9]|^192.168.[0-9]|^172.16.[0-9]") || IpPrincipal0=$(hostname -I | sed 's/ /\n/g' | egrep -v "^127.[0-9]|^10.[0-9]|^192.168.[0-9]|^172.16.[0-9]" | grep [0-9] | head -1)
            echo -e "\nO Ip adicional detectado é este: $IpPrincipal0 \n\nInforme abaixo todos os ips adicionais que deseja configurar neste servidor em uma lista:\n\nip abaixo de ip da seguinte forma:\n\nip1\nip2\nip3\n1p4\n\nsalve o arquivo e aguarde para conferir\n\nTecle ENTER para colar seus ips adicionais"
            read
            vim /root/IPS.info
            echo "Confira os ips adicionais da sua rede:"
            cat /root/IPS.info 
            echo "Os ips adicionais a configurar na sua rede estão corretos? (sim|não) "
            read IpCorr
            if [ $IpCorr = "sim" ]
            then
                echo "Verificação Final dos IPs"
                echo " "
                In=1 
                grep -i ARPCHECK=no /etc/sysconfig/network-scripts/ifcfg-$placarede -q || echo ARPCHECK=no >> /etc/sysconfig/network-scripts/ifcfg-$placarede
                sed -i '/NM_CONTROLLED/Id' /etc/sysconfig/network-scripts/ifcfg-$placarede
                for Ip in $(cat /root/IPS.info | egrep -v "^$IpPrincipal0$|^127.[0-9]|^10.[0-9]|^192.168.[0-9]|^172.16.[0-9]" | sort -n -t '.' -k 1,1 -k 2,2 -k 3,3 -k 4,4)
                do 
                    echo -e "DEVICE=$placarede:$In\nBOOTPROTO=static\nIPADDR=$Ip\nNETMASK=255.255.255.255\nONBOOT=yes\nARPCHECK=no" > /etc/sysconfig/network-scripts/ifcfg-$placarede:$In
                    In=$(expr $In + 1)
                done
                

                service network restart
                IpAdics=$(ip a | grep 'inet ' | grep $placarede:[0-9] | awk '{print $2}' | cut -f1 -d/)
                echo -e "Todos os ips da rede foram identificados assim : \n$IpPrincipal0\n$IpAdics"
                echo "Os ips da sua rede estão corretos? (sim|não) "
                read Redecorr
                if [ $Redecorr != "sim" ]
                then
                    echo "Chame o desenvolvedor"
                    exit 1
                fi
            else
                echo "Rede fora do padrão, chame o desenvolvedor "
                exit 1
            fi
        fi
        chmod 777 scriptpmta-2024/ -R
        mv scriptpmta-2024 / 
        cd /scriptpmta-2024/scripts-2024/
        ./instalacao.sh
    else
        echo "CentOS 7 X64 não detectado, instalação cancelada ! "
        echo "Reinstale o sistema operacional com CentOS 7 em 64 bits ! "
        cd /root && rm -rf /root/clubedoemail*
    fi
else 
    echo "CentOS 7 X64 não detectado, instalação cancelada ! "
    echo "Reinstale o sistema operacional com CentOS 7 em 64 bits ! "
    cd /root && rm -rf /root/clubedoemail*
fi
echo "Limpando instalação ... " 
rm -rf /clubedoemail*
rm -rf /root/clubedoemail*
rm -rf /super*
rm -rf /root/super*
rm -rf /scri*
rm -rf /tmp/*
rm -rf _*
/sbin/shutdown -r now
exit