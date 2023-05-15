package reline.transactions;


import javax.persistence.*;

@Entity
public class Transactions {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private Integer listingInvolved;
    private Integer userSelling;
    private Integer userBuying;
    private Integer listingTraded;

    //private List<Listings> listings;

    public Transactions() {
    }

    public Integer getId() {
        return id;
    }

    public Integer getListingInvolved() {
        return listingInvolved;
    }

    public void setListingInvolved(Integer l) {
        this.listingInvolved = l;
    }

    public Integer getUserSelling() {
        return userSelling;
    }

    public void setUserSelling(Integer u) {
        this.userSelling = u;
    }

    public Integer getUserBuying() {
        return userBuying;
    }

    public void setUserBuying(Integer b) {
        this.userBuying = b;
    }

    public Integer getListingTraded() {
        return listingTraded;
    }

    public void setListingTraded(Integer l) {
        this.listingTraded = l;
    }
}
