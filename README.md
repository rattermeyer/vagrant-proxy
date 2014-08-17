Vagrant Proxy VM
================

Diese VM bietet zwei Komponenten

* Sonatype Nexus (Binary Artifact Repo)
* apt-cacher-ng (Caching von .deb Paketen)

Ich verwende diese VM im wesentlich, um bei vielen VMs etc APT Pakete vorzuhalten und große / 3rd Party Werkzeuge zu speichern.
So kommen in das Sonatype Nexus 
* Oracle XE Datenbank
* Oracle JDK
* Wildfly
* Eclipse
* IntelliJ IDEA

Dies beschleunigt die Entwicklung / Provisioning von Entwicklermaschinen
