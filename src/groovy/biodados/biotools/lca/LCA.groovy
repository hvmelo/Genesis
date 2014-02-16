package biodados.biotools.lca

import biodados.biotools.taxonomy.TaxonomyTree
import biodados.biotools.taxonomy.TaxonEntry

import org.apache.log4j.Logger

import javax.swing.tree.DefaultMutableTreeNode

/**
 * Finds the Lowest Common Ancestor from a taxonomy tree.
 * User: henrique
 * Date: 15/12/2009
 * Time: 20:13:06
 */
class LCA {

    static Logger logger = Logger.getLogger(LCA.class)

    TaxonomyTree tree
        

     /**
      *  Find the lowest common ancestor for a node list.
      */
//    def lowestCommonAncestor(Collection<Integer> taxIdList, List doNotIncludeChildrenOf = null, String returnType = 'entry') {
//        logger.debug "Calculating the LCA for taxId list."
//        def nodeMap = tree.findNodeMapByTaxIds(taxIdList)
//
//        if (doNotIncludeChildrenOf != null && doNotIncludeChildrenOf.size() > 0) {
//            logger.debug  "Excluding nodes which are descendants of the not wanted list."
//            def notIncludeMap = tree.findNodeMapByTaxIds(doNotIncludeChildrenOf)
//            def beforeSize = nodeMap.size()
//            nodeMap = nodeMap.findAll {taxid, node ->
//                def ancestor = notIncludeMap.find {parentTaxId, parentNode ->
//                    node.isNodeAncestor(parentNode)
//                }?.value
//                if (ancestor) {
//                    logger.debug "${node.userObject.name} (txid ${taxid}) removed as it is descendant of ${ancestor.userObject.name} (txid ${ancestor.userObject.taxId}). "
//                    return false
//                }
//                return true
//            }
//            def afterSize = nodeMap.size()
//
//            logger.debug "Size before removal: ${beforeSize}. Size after removal: ${afterSize}."
//
//        }
//
//        // Get a random node to be the first LCA
//        def lca = nodeMap?.find{true}?.getValue()
//        if (lca) {
//            nodeMap.values().each { node ->
//                if (!lca.isNodeDescendant(node)) {
//                    lca = lca.getSharedAncestor(node)
//                }
//            }
//            logger.debug "LCA Found. Tax id: $lca.userObject.taxId ($lca.userObject.name)."
//        }
//        else
//        {
//            def error = "LCA cannot be calculated. No valid tax ids were found."
//            logger.error(error)
//            throw new LCAException(error)
//        }
//
//        switch (returnType) {
//            case ('entry') :
//                return lca?.userObject
//            case ('node') :
//                return lca
//            case ('taxid') :
//                return lca?.userObject.taxId
//        }
//    }

    /**
     *  Find the lowest common ancestor for a node list.
     */
    def lowestCommonAncestor(Collection<Integer> taxIdList, List doNotIncludeChildrenOf = null, String returnType = 'entry') {
        logger.debug "Calculating the LCA for taxId list."
        List<DefaultMutableTreeNode> nodes = tree.findNodesByTaxIds(taxIdList)

        if (doNotIncludeChildrenOf != null && doNotIncludeChildrenOf.size() > 0) {
            logger.debug  "Excluding nodes which are descendants of the not wanted list."
            def notIncludeNodes = tree.findNodesByTaxIds(doNotIncludeChildrenOf)
            def beforeSize = nodes.size()
            nodes.retainAll { node ->
                def ancestor = notIncludeNodes.find {parentNode ->
                    node.isNodeAncestor(parentNode)
                }
                if (ancestor) {
                    logger.debug "${node.userObject.name} (txid ${node.userObject.taxId}) removed as it is descendant of ${ancestor.userObject.name} (txid ${ancestor.userObject.taxId}). "
                    return false
                }
                return true
            }
            def afterSize = nodes.size()

            logger.debug "Size before removal: ${beforeSize}. Size after removal: ${afterSize}."

        }

        // Find the lca
        def lca = nodes.first()
        if (lca) {
            nodes.each { node ->
                lca = lca.getSharedAncestor(node)
            }
            logger.debug "LCA Found. Tax id: $lca.userObject.taxId ($lca.userObject.name)."
        }
        else
        {
            def error = "LCA cannot be calculated. No valid tax ids were found."
            logger.error(error)
            throw new LCAException(error)
        }

        switch (returnType) {
            case ('entry') :
                return lca?.userObject
            case ('node') :
                return lca
            case ('taxid') :
                return lca?.userObject.taxId
        }
    }


    DefaultMutableTreeNode lowestCommonAncestor(Map<Integer, DefaultMutableTreeNode> nodeMap, String returnType = 'entry') {
        logger.debug "Calculating the LCA for a node map."


        // Get a random node to be the first LCA
        def lca = nodeMap?.find{true}?.getValue()
        if (lca) {
            nodeMap.values().each { node ->
                if (!lca.isNodeDescendant(node)) {
                    lca = lca.getSharedAncestor(node)
                }
            }
            logger.debug "LCA Found. Tax id: $lca.userObject.taxId ($lca.userObject.name)."
        }
        else
        {
            def error = "LCA cannot be calculated. No valid tax ids were found."
            logger.error(error)
            throw new LCAException(error)
        }

        switch (returnType) {
            case ('entry') :
                return lca?.userObject
            case ('node') :
                return lca
            case ('taxid') :
                return lca?.userObject.taxId
        }
    }




    Map<DefaultMutableTreeNode, Collection<Integer>> findFirstIndependentLCAsUnderNode(Collection<Integer> taxIdList, DefaultMutableTreeNode topNode) {

        Map<DefaultMutableTreeNode, Collection<Integer>> lcaNodesMap = [:]

        Map<Integer, DefaultMutableTreeNode> mapNodes = tree.findNodeMapByTaxIds(taxIdList)

        mapNodes.each {Integer taxId, DefaultMutableTreeNode node ->

            boolean included = false

            Map<DefaultMutableTreeNode, Collection<Integer>> toInclude = [:]
            List<DefaultMutableTreeNode> toRemove = []

            lcaNodesMap.each {DefaultMutableTreeNode lcaNode, Collection<Integer> taxids ->
                if (node.isNodeAncestor(lcaNode)) {
                    taxids << taxId
                    included = true
                    return
                }

                DefaultMutableTreeNode newLCANode = lcaNode.getSharedAncestor(node)

                if (newLCANode != topNode && newLCANode.isNodeAncestor(topNode) && newLCANode != lcaNode) {
                    toInclude[newLCANode] = [taxids, taxId].flatten()
                    toRemove << lcaNode
                    included = true
                    return
                }
            }

            if (!toRemove.isEmpty()) {
                toRemove.each {
                    lcaNodesMap.remove(it)
                }
            }

            if (!toInclude.isEmpty()) {
               lcaNodesMap.putAll(toInclude)
            }

            if (!included) {

                lcaNodesMap[node] = [taxId]
            }

        }

        return lcaNodesMap

    }


}