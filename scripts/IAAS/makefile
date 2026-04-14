#VBoxManage storagectl "Nombre_de_tu_VM" --name "NVMe Controller" --portcount 8
#VBoxManage list hdds
# Busca el UUID del disco que apunte a esa ruta y luego:
#VBoxManage closemedium disk <UUID> --delete

# Include sensitive data from CONFIG.mk
-include CONFIG.mk

export MASTER_IP
export HOSTNAME_MASTER
export WORKER_IP
export HOSTNAME_WORKER

generate-hosts:
	@echo "Generando archivo hosts en ../../dynamic/hosts..."
	@mkdir -p ../../dynamic
	@echo "127.0.0.1       localhost             localhost.localdomain localhost4 localhost4.localdomain4" > ../../dynamic/hosts
	@echo "::1             localhost             localhost.localdomain localhost6 localhost6.localdomain6" >> ../../dynamic/hosts
	@master_ip_clean=$$(echo $(MASTER_IP) | tr -d '"') ; \
	hostname_master_clean=$$(echo $(HOSTNAME_MASTER) | tr -d '"') ; \
	ips=($$master_ip_clean) ; \
	hosts=($$hostname_master_clean) ; \
	len_master_ip=$${#ips[@]} ; \
	len_hostname_master=$${#hosts[@]} ; \
	if [[ $$len_master_ip -ne $$len_hostname_master ]]; then \
	echo "Error: The number of master IPs does not match the number of master hostnames." ; \
	exit 1 ; \
	fi ; \
	for (( i=0; i<$$len_master_ip; i++ )); do \
	echo "$${ips[$$i]}   $${hosts[$$i]}" >> ../../dynamic/hosts ; \
	done


	@worker_ip_clean=$$(echo $(WORKER_IP) | tr -d '"') ; \
	hostname_worker_clean=$$(echo $(HOSTNAME_WORKER) | tr -d '"') ; \
	ips=($$worker_ip_clean) ; \
	hosts=($$hostname_worker_clean) ; \
	len_worker_ip=$${#ips[@]} ; \
	len_hostname_worker=$${#hosts[@]} ; \
	if [[ $$len_worker_ip -ne $$len_hostname_worker ]]; then \
		echo "Error: The number of worker IPs does not match the number of worker hostnames." ; \
	exit 1 ; \
	fi ; \
	for (( i=0; i<$$len_worker_ip; i++ )); do \
	echo "$${ips[$$i]}   $${hosts[$$i]}" >> ../../dynamic/hosts ; \
	done
	@echo "Archivo hosts generado correctamente."

deleteVM:

	@for MASTER in $(DATA_MASTER); do \
		HOSTNAME=$$(echo $$MASTER | cut -d: -f1); \
		#echo "hostname - $$HOSTNAME"; \
		IPADDRESS=$$(echo $$MASTER | cut -d: -f2); \
		#echo "$$IPADDRESS - IPAddressVM"; \
		#echo "$(MASK_MASTER) - mask"; \
		#echo "$(GATEWAY_MASTERS) - gateway"; \
		DNS_TMP="$(DNS_SERVERS)"; \
		#echo "$${DNS_TMP// /;} - dns"; \
		#echo "$(HTTP_PROTO_IGNITION) - httpProtocolIgnition"; \
		#echo "$(HTTP_IP_IGNITION) - IPAddressHttpIgnition"; \
		#echo "$(HTTP_PORT_IGNITION) - httpPortIgnition"; \
		#echo "$(OVA_FILE) - OVAFILE"; \
		#echo "$(K8S_VERSION) - k8s_version"; \
		./deleteVM.sh "$$HOSTNAME"; \
	done
startVM:

	@echo "DATA_MASTER: $(DATA_MASTER)"
	@echo "DATA_WORKER: $(DATA_WORKER)"

	@for MASTER in $(DATA_MASTER); do \
		HOSTNAME=$$(echo $$MASTER | cut -d: -f1); \
		#echo "hostname - $$HOSTNAME"; \
		IPADDRESS=$$(echo $$MASTER | cut -d: -f2); \
		#echo "$$IPADDRESS - IPAddressVM"; \
		#echo "$(MASK_MASTER) - mask"; \
		#echo "$(GATEWAY_MASTERS) - gateway"; \
		DNS_TMP="$(DNS_SERVERS)"; \
		#echo "$${DNS_TMP// /;} - dns"; \
		#echo "$(HTTP_PROTO_IGNITION) - httpProtocolIgnition"; \
		#echo "$(HTTP_IP_IGNITION) - IPAddressHttpIgnition"; \
		#echo "$(HTTP_PORT_IGNITION) - httpPortIgnition"; \
		#echo "$(OVA_FILE) - OVAFILE"; \
		#echo "$(K8S_VERSION) - k8s_version"; \
		./startVM.sh --nameVM "$$HOSTNAME" --role master --prefixButaneIgnitionName preconfig --IPAddressVM "$$IPADDRESS" --maskVM "$(MASK_MASTER)" --gatewayVM "$(GATEWAY_MASTERS)" --dnsVM "$${DNS_TMP// /;}"  --httpProtocolIgnition "$(HTTP_PROTO_IGNITION)" --IPAddressHttpIgnition "$(HTTP_IP_IGNITION)" --httpPortIgnition "$(HTTP_PORT_IGNITION)" --OVAFILE "$(OVA_FILE)" --k8s_version "$(K8S_VERSION)"; \
	done

listNICS:
	vboxmanage list hostonlyifs
