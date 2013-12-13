package biodados.biotools.taxonomy

import javax.xml.bind.annotation.XmlAccessorType
import javax.xml.bind.annotation.XmlAccessType

@XmlAccessorType(XmlAccessType.FIELD)
class TaxonEntry {

    Integer taxId

	Integer parentId

	String name

	String rank

    Integer level

    Set oldTaxIds


    public String toString() {
        return name + "(txid: " + taxId + ")"
    }

}
