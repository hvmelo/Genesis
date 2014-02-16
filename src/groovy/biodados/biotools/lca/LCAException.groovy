package biodados.biotools.lca

/**
 * Created by IntelliJ IDEA.
 * User: henrique
 * Date: 13/01/2010
 * Time: 16:13:11
 * To change this template use File | Settings | File Templates.
 */
class LCAException extends Exception {

    def LCAException() {
        super();
    }

    def LCAException(String message) {
        super(message);
    }

    def LCAException(Throwable cause) {
        super(cause);
    }

    def LCAException(String message, Throwable cause) {
        super(message, cause);  
    }


}
