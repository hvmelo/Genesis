import biodados.biotools.lca.LCA

class BootStrap {

    def taxonomyTree
    def taxonomyDao
    def lca
    def sessionFactory

    def init = { servletContext ->

        if (!taxonomyTree.rootNode) {

            taxonomyDao.sessionFactory = sessionFactory
            taxonomyDao.init()
            taxonomyTree.mountTaxonomyTree()
            lca = new LCA(tree: taxonomyTree)


        }


    }
    def destroy = {
    }
}
