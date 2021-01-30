# solarwinds_orion module

## Table of Contents
1. [Description](#description)
2. [Setup](#setup)
3. [Tasks](#tasks)
    * [solarwinds_orion::version](#version)

## Description
This module delivers tasks for detection and remediation of known vulnerabilities.

## Setup
Install the remediation module with <pre>puppet module install solarwinds_orion</pre>

## Tasks
### version
<pre>solarwinds_orion::version</pre>
#### Description
Checks if the SolarWinds Orion Platform is installed and reports the version and hotfix version.
#### Usage
Note this task uses powershell and is only applicable to Windows targets.
#### Output
Not installed:
<pre>
{
    "status": "SolarWinds Orion is not installed",
    "version": "",
    "hotfix": 0
}
</pre>
Installed and version detected successfully:
<pre>
{
  "status": "SolarWinds Orion 2020.2.1 HF2 detected",
  "version": "2020.2.1",
  "hotfix": 2
}
or:
{
  "status": "SolarWinds Orion 2020.2.4 (no hotfix) detected",
  "version": "2020.2.4",
  "hotfix": 0
}
</pre>
Installed and version not detected:
<pre>
{
  "status": "SolarWinds Orion detected, login to check the hotfix version",
  "version": "",
  "hotfix": 0
}
</pre>
Installed and version partially detected:
<pre>
{
  "status": "SolarWinds Orion 2020.2.4 detected, login to check the hotfix version",
  "version": "2020.2.4",
  "hotfix": 0
}
</pre>
