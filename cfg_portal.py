# vim: set fileencoding=utf-8 :
"""Este script configura um Portal Modelo 3.0 para hospedagem

Ele eh utilzado na opcao post-extras da receita collective.recipe.plonesite. 
Sera executado depois de rodar o perfil QuickInstaller e o GenericSetup.

Autor:  Fabio Rauber
E-mail: fabiorauber@gmail.com

@param portal: O Plone site como definido pela opcao site-id.
@param app: Raiz do Zope
"""

import logging
from zope.component import getUtility
from plone.registry.interfaces import IRegistry
from plone.caching.interfaces import ICacheSettings
from plone.app.caching.interfaces import IPloneCacheSettings
from plone.cachepurging.interfaces import ICachePurgingSettings

logger = logging.getLogger('collective.recipe.plonesite')

smtp_server = '%SMTP_SERVER%'
smtp_port   = '%SMTP_PORT%'
email       = '%EMAIL%'
password    = '%PASSWORD%'
title       = '%TITLE%'
descr       = '%DESCR%'
rootpwd     = '%ROOTPWD%'
hostname    = '%HOSTNAME%'

try:
  app.acl_users.users.updateUserPassword('admin', rootpwd)
except Exception as e:
  logger.error('An error ocurred while changing admin password: %s.' % str(e))
  

try:
  portal.MailHost.manage_makeChanges(title='SMTP',
                                   smtp_host=smtp_server,
                                   smtp_port=smtp_port,
                                   smtp_uid='',
                                   smtp_pwd='')
except Exception as e:
  logger.error('An error ocurred with MailHost configuration: %s.' % str(e))

try:
  portal.portal_registration.addMember('adm', password)
  portal.portal_groups.addPrincipalToGroup('adm', 'Administrators')
  portal.manage_changeProperties(title=title, description=descr, email_from_address=email, email_from_name=(title + ' de ' + descr))
except Exception as e:
  logger.error('An error ocurred with properties or user configuration: %s.' % str(e))

try:
  registry = getUtility(IRegistry)
  cacheSettings = registry.forInterface(ICacheSettings)
  cacheSettings.enabled = True

  ploneSettings = registry.forInterface(IPloneCacheSettings)
  ploneSettings.enableCompression = True

  #purgingSettings = registry.forInterface(ICachePurgingSettings)
  #purgingSettings.enabled = True
  #purgingSettings.cachingProxies = ('http://<%= @caching_proxy %>:80',)

except Exception as e:
  logger.error('An error ocurred with cache settings configuration: %s.' % str(e))


try:
  app.virtual_hosting.set_map(hostname + '/VirtualHostBase/https/' + hostname + '/portal/VirtualHostRoot\nwww.' + hostname + '/VirtualHostBase/https/www.' + hostname + '/portal/VirtualHostRoot')

except Exception as e:
  logger.error('An error ocurred while configuring virtual_hosting: %s.' % str(e))

