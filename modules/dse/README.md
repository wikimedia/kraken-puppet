# Puppet module to install components of Datastax Enterprise.

## Description
Currently installs dse-full and opscenter.
Note that, in order for this module to work, you will have to ensure that:
* sun jre version 6 or greater is installed
* your package manager is configured with a repository containing the
  DSE packages.  See: http://www.datastax.com/docs/datastax_enterprise2.0/install_dse_packages#installing-datastax-enterprise-debian-packages

## Usage

### dse
<pre>
include dse # includes all components
</pre>

