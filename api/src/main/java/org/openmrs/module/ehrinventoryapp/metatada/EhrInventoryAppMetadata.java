package org.openmrs.module.ehrinventoryapp.metatada;

import org.openmrs.module.metadatadeploy.bundle.AbstractMetadataBundle;
import org.openmrs.module.metadatadeploy.bundle.Requires;
import org.springframework.stereotype.Component;

import static org.openmrs.module.metadatadeploy.bundle.CoreConstructors.idSet;
import static org.openmrs.module.metadatadeploy.bundle.CoreConstructors.privilege;
import static org.openmrs.module.metadatadeploy.bundle.CoreConstructors.role;

/**
 * Implementation of access control to the app.
 */
@Component
@Requires(org.openmrs.module.kenyaemr.metadata.SecurityMetadata.class)
public class EhrInventoryAppMetadata extends AbstractMetadataBundle {

    public static class _Privilege {

        public static final String APP_EHRINVENTORYAPP_MODULE_APP = "App: ehrinventoryapp.ehrinventoryapp";
    }

    public static final class _Role {

        public static final String APPLICATION_EHRINVENTORYAPP_MODULE = "Inventory";
    }

    /**
     * @see AbstractMetadataBundle#install()
     */
    @Override
    public void install() {
        install(privilege(_Privilege.APP_EHRINVENTORYAPP_MODULE_APP, "Able to access Key EHR Inventroy app module"));
        install(role(_Role.APPLICATION_EHRINVENTORYAPP_MODULE, "Can access EHR Inventory module App",
                idSet(org.openmrs.module.kenyaemr.metadata.SecurityMetadata._Role.API_PRIVILEGES_VIEW_AND_EDIT),
                idSet(_Privilege.APP_EHRINVENTORYAPP_MODULE_APP)));
    }
}
