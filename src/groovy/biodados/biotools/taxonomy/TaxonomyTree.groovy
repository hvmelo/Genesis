package biodados.biotools.taxonomy

import org.apache.log4j.Logger
import javax.swing.tree.DefaultMutableTreeNode



public class TaxonomyTree {

    static Logger logger = Logger.getLogger(TaxonomyTree.class)

    DefaultMutableTreeNode rootNode

    //Este map auxilia em encontrar nodos que ja foram criados.
    def mapNodes = [:] as HashMap

    TaxonomyDAO dao



     /**
      *  Mount the taxonomy tree.
      */
    def mountTaxonomyTree()	{

        logger.debug "Building full taxonomy tree."

		logger.debug "Retrieving all database taxon entries."


        def mapEntries = dao.findAllTaxonEntries()

		logger.debug "Retrieving merged entries..."

        def mergedMap = dao.buildMergedMap()

        logger.debug mapEntries.size() + " taxons have been retrieved."



		//Adicionando nodo raiz
		logger.debug "Creating root node."
		def rootEntry = mapEntries[1]
        if (mergedMap[rootEntry.taxId]) {
            rootEntry.oldTaxIds = new HashSet(mergedMap[rootEntry.taxId])
        }
        rootNode = new DefaultMutableTreeNode(rootEntry)
		mapNodes[rootEntry.taxId] = rootNode
		mapEntries.remove(1)

		logger.debug "Root node successfully created."
		logger.debug"Filling tree."

		while(!mapEntries.isEmpty())
		{

			def tmpTaxId = mapEntries.firstEntry().key
			def tmpEntry = mapEntries.firstEntry().value
            if (mergedMap[tmpEntry.taxId]) {
                tmpEntry.oldTaxIds = new HashSet(mergedMap[tmpEntry.taxId])
            }
			mapEntries.remove(tmpTaxId)

			DefaultMutableTreeNode tmpNode = new DefaultMutableTreeNode(tmpEntry)
			mapNodes[tmpTaxId] = tmpNode
			String taxonName = tmpEntry.name
			logger.trace "Finding ancestors for node with tax id #$tmpEntry.taxId ($taxonName)."

			boolean treeFound = false

			//Insere nodos no mapa ate que um nodo da arvore seja encontrado
			while (!treeFound)
			{
				//Encontra o id do pai
				logger.trace("Finding parent for $tmpEntry.name (tax id #$tmpEntry.taxId).")
				def tmpParentId = tmpEntry.parentId

				def tmpParentNode = null
				def tmpParentEntry = null

				//Verifica se o nodo do pai ja de encontra no mapa de nodos
				if (mapNodes.containsKey(tmpParentId))
				{
					logger.trace "Parent found in the tree."
					tmpParentNode = mapNodes[tmpParentId]
					tmpParentEntry = tmpParentNode.getUserObject()
					treeFound = true //Se encontra nao e mais preciso testar os nodos ancentrais

				}
				else
				{
					//Se nao estava na arvore ainda, procura o registro correspondente ao pai
					logger.trace "Parent was not in tree. Continue finding an ancestor in the tree."

					tmpParentEntry = mapEntries[tmpParentId]
                    if (mergedMap[tmpParentEntry.taxId]) {
                        tmpParentEntry.oldTaxIds = new HashSet(mergedMap[tmpParentEntry.taxId])
                    }
					//Cria um novo nodo para o pai
					logger.trace "Parent found: $tmpParentEntry.name. Creating new tree node for it."
					tmpParentNode = new DefaultMutableTreeNode(tmpParentEntry)
					mapEntries.remove(tmpParentId)
				}
				logger.trace "Adding child node to parent."
				//Adiciona filho ao pai
				tmpParentNode.add(tmpNode)
				//Insere ou atualiza o pai no mapa de nodos
				mapNodes[tmpParentId] = tmpParentNode
				//O pai agora sera testado
				tmpNode = tmpParentNode
				tmpEntry = tmpParentEntry

			}
		}

        logger.debug "Filling depths..."

        mapNodes.each { key, value ->

            value.userObject.level = mapNodes[key].level
        }

		logger.debug "Tree successfully built."

	}

    DefaultMutableTreeNode findNodeByTaxId(Integer taxId) {

        logger.trace  "Finding node for taxId #$taxId."
        //def enumNodes = rootNode.preorderEnumeration()
		//def node = enumNodes.find{it.userObject.taxId == taxId}
        def node = mapNodes[taxId]
        if (!node) {
            //Verifica se era um tax_id que se modificou
            node = mapNodes.find{nodeTxid, nodeEntry ->
                nodeEntry.userObject.oldTaxIds ? taxId in nodeEntry.userObject.oldTaxIds : false
            }
            if (!node) {
                logger.error "Node not found for taxId #$taxId."
            } else {
                logger.trace  "Node found. Taxon name: ${node.userObject?.name}. Warning: TaxId #${taxId} is now merged with #${node.userObject.taxId}."
            }
        } else {
           logger.trace  "Node found. Taxon name: ${node.userObject?.name}."
        }                
        return node
	}

    Map<Integer, DefaultMutableTreeNode> findNodeMapByTaxIds(Collection<Integer> taxIdList) {

        logger.trace "Finding node map for taxId list."

        Map<Integer, DefaultMutableTreeNode> mapReturn = [:]

        for (key in mapNodes.keySet()) {
            if (key in taxIdList) {
               mapReturn[key] = mapNodes[key]
            }



        }



//        def nodesNotFound = taxIdList.findAll { taxId ->
//            !(taxId in nodeMap.keySet()) && !(nodeMap.find{key, value -> value.userObject.oldTaxIds?.contains(taxId)})
//        }
//
//        if (!nodesNotFound.isEmpty()) {
//            logger.warn "No nodes were found for the following tax ids: ${nodesNotFound.join(',')}."
//        }

        logger.trace "${mapReturn.size()} node were found out of ${taxIdList.size()} tax ids."
        return mapReturn
    }

    List<DefaultMutableTreeNode> findNodesByTaxIds(Collection<Integer> taxIdList) {

        logger.trace "Finding nodes for taxId list."

        List<DefaultMutableTreeNode> returnNodes =  taxIdList.collect { taxId ->

            DefaultMutableTreeNode node = (DefaultMutableTreeNode) mapNodes.get(taxId)
            if (node == null) {
                logger.debug "Cannot find a node for taxid ${taxId}."

            }
            return node
        }

        returnNodes.removeAll {it == null}

        logger.trace "${returnNodes.size()} node were found out of ${taxIdList.size()} tax ids."
        return returnNodes
    }



    def compareTaxons(TaxonEntry entry1, TaxonEntry entry2) {
        logger.trace "Finding ancestor between $entry1.name and $entry2.name."

        if (entry1.taxId.equals(entry2.taxId)) {

            return 0
        }

        def node1 = findNodeByTaxId(entry1.taxId)
        def node2 = findNodeByTaxId(entry2.taxId)

        if (node1.isNodeAncestor(node2)) {
            logger.trace "$entry1.name is ancestor of $entry2.name."
            return 1
        }
        logger.trace "$entry2.name is ancestor of $entry1.name."
        return -1       
    }


    DefaultMutableTreeNode subTree(Collection<Integer> taxIds, Integer treeRootTaxId = null) {
        logger.debug "Generating a subtree including ${taxIds.size()} leaf node(s)."

        def mapNodes = [:]

        if (treeRootTaxId) {
            DefaultMutableTreeNode rootNode = findNodeByTaxId(treeRootTaxId)
            TaxonEntry rootEntry = rootNode.userObject
            logger.debug "Root node is forced on ${rootEntry.name}. Tax id: ${rootEntry.taxId}."

            mapNodes[treeRootTaxId] = rootNode

        }

        Map<Integer, DefaultMutableTreeNode> nodesMap = findNodeMapByTaxIds(taxIds)

        while (!nodesMap.isEmpty()) {
            boolean treeFound = false

            //Insere nodos no mapa ate que um nodo da arvore seja encontrado
            while (!treeFound) {
                //Encontra o id do pai
                def tmpParentId = tmpEntry.parentId

                def tmpParentNode = null
                def tmpParentEntry = null

                //Verifica se o nodo do pai ja de encontra no mapa de nodos
                if (mapNodes.containsKey(tmpParentId))
                {
                    logger.trace "Parent found in the tree."
                    tmpParentNode = mapNodes[tmpParentId]
                    tmpParentEntry = tmpParentNode.getUserObject()
                    treeFound = true //Se encontra nao e mais preciso testar os nodos ancentrais

                }
                else
                {
                    //Se nao estava na arvore ainda, procura o registro correspondente ao pai
                    logger.trace "Parent was not in tree. Continue finding an ancestor in the tree."

                    tmpParentEntry = mapEntries[tmpParentId]

                    //Cria um novo nodo para o pai
                    logger.trace "Parent found: $tmpParentEntry.name. Creating new tree node for it."
                    tmpParentNode = new DefaultMutableTreeNode(tmpParentEntry)
                    mapEntries.remove(tmpParentId)
                }
                logger.trace "Adding child node to parent."
                //Adiciona filho ao pai
                tmpParentNode.add(tmpNode)
                //Insere ou atualiza o pai no mapa de nodos
                mapNodes[tmpParentId] = tmpParentNode
                //O pai agora sera testado
                tmpNode = tmpParentNode
                tmpEntry = tmpParentEntry

            }
        }




        return subTreeRoot

    }

    static def findAllDescendants(def parentNode, Boolean onlyLeaves = true, String returnType = 'entries') {

        def parentEntry = parentNode.userObject
        logger.debug "Finding all descendants for ${parentEntry?.name} (taxid: ${parentEntry?.taxId})."

        def children = parentNode.preorderEnumeration().toList()

        if (onlyLeaves) {
            children.retainAll{it.isLeaf()}

        }

        switch (returnType) {
            case ('entries') :
                return children?.collect{it.userObject}
            case ('nodes') :
                return children
            case ('taxids') :
                return children?.collect{it.userObject.taxId}
        }

    }

    def removeRanks(List ranks, Collection doNotRemoveSet) {

		logger.debug "Started removing ${ranks.size()} ranks from the tree. Current number of nodes is ${size()}."

        def filtered = rootNode.preorderEnumeration().findAll { !it.isLeaf() && !it.isRoot() }

		logger.debug "${filtered.size()} are not leaf and not root."

        def ranked = 0

        filtered.each { node ->
            def taxId = node.userObject.taxId
            def rank = node.userObject.rank

            if (rank in ranks && !(taxId in doNotRemoveSet)) {
                ranked++               
                def childList = []
                node.children().each { child ->
                    childList.add(child)
                }

                childList.each { child ->
                    node.parent.add(child)
                }

                node.removeFromParent()
                mapNodes.remove(node.userObject.taxId)
            }

		}

        logger.debug "${ranked} nodes were removed. Current number of nodes is ${size()}."

    }


    def Integer size() {
        return rootNode.preorderEnumeration().toList().size()    
    }

    def Boolean isMounted() {
        return rootNode != null
    }


}