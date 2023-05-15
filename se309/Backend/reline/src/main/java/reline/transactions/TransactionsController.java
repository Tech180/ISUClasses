package reline.transactions;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import reline.listings.Listings;
import reline.listings.ListingsRepository;
import reline.users.User;
import reline.users.UserRepository;

import java.util.*;

@RestController
public class TransactionsController {

    @Autowired
    UserRepository ur;

    @Autowired
    TransactionsRepository tr;

    @Autowired
    ListingsRepository lr;

    @GetMapping(path = "transactions")
    List<Transactions> getAllTransactions() { return tr.findAll(); }

    @GetMapping(path = "transactions/{id}")
    List<Object> getTransaction(@PathVariable Integer id) {
        if(tr.findById(id).isPresent()) {
            List<Object> info = new ArrayList<>();
            Transactions t = tr.findById(id).get();
            if(ur.findById(t.getUserBuying()).isPresent() && ur.findById(t.getUserSelling()).isPresent() && lr.findById(t.getListingInvolved()).isPresent()) {
                User buyer = ur.findById(t.getUserBuying()).get();
                User seller = ur.findById(t.getUserSelling()).get();
                Listings listing = lr.findById(t.getListingInvolved()).get();
                info.add(buyer);
                info.add(seller);
                info.add(listing);
            }
            if(t.getListingTraded() != null) {
                if (lr.findById(t.getListingTraded()).isPresent()) {
                    Listings listing2 = lr.findById(t.getListingTraded()).get();
                    info.add(listing2);
                }
            }
            return info;
        }
        return null;
    }

    @DeleteMapping(path = "transactions/delete/{id}")
    String deleteTransactions(@PathVariable Integer id){
        try {
            if(tr.findById(id).isPresent() == false) {
                throw new Exception();
            }
            tr.deleteById(id);
            return "success";
        } catch(Exception e) {
            return "failure";
        }
    }

    @PostMapping(path = "transactions/new/{s}/{b}/{l}")
    String createTransaction(@PathVariable Integer s, @PathVariable Integer b, @PathVariable Integer l) {
        try {
            Transactions newTransaction = new Transactions();
            newTransaction.setUserSelling(s);
            newTransaction.setUserBuying(b);
            newTransaction.setListingInvolved(l);
            if(ur.findById(s).isPresent() && ur.findById(b).isPresent() && lr.findById(l).isPresent()) {
                Listings list = lr.findById(l).get();
                float price = list.getPrice();
                User buyer = ur.findById(b).get();
                float balance = buyer.getBalance();
                if(balance < price) {
                    return "failure";
                }
                User seller = ur.findById(s).get();
                buyer.subBalance(price);
                seller.addBalance(price);
                list.setHidden("true");
                tr.save(newTransaction);
                lr.save(list);
                ur.save(seller);
                ur.save(buyer);
                return "success";
            }
            return "failure";
        } catch(Exception e) {
            return "failure";
        }
    }

    @PostMapping(path = "transactions/newTrade/{s}/{b}/{l}/{lt}")
    String createTransaction(@PathVariable Integer s, @PathVariable Integer b, @PathVariable Integer l, @PathVariable Integer lt) {
        try {
            Transactions newTransaction = new Transactions();
            newTransaction.setUserSelling(s);
            newTransaction.setUserBuying(b);
            newTransaction.setListingInvolved(l);
            newTransaction.setListingTraded(lt);
            if(ur.findById(s).isPresent() && ur.findById(b).isPresent() && lr.findById(l).isPresent() && lr.findById(lt).isPresent()) {
                Listings list = lr.findById(l).get();
                Listings tradedList = lr.findById(lt).get();
                User buyer = ur.findById(b).get();
                String buyerUser = buyer.getUsername();
                Integer buid = buyer.getId();
                list.setUid(buid);
                list.setUsername(buyerUser);
                if(buyer.getType().equals("Paid")){
                    list.setBumped("true");
                } else {
                    list.setBumped("false");
                }
                User seller = ur.findById(s).get();
                String sellerUser = seller.getUsername();
                Integer suid = seller.getId();
                tradedList.setUid(suid);
                tradedList.setUsername(sellerUser);
                if(seller.getType().equals("Paid")){
                    tradedList.setBumped("true");
                } else {
                    tradedList.setBumped("false");
                }
                tr.save(newTransaction);
                lr.save(list);
                lr.save(tradedList);
                return "success";
            }
            return "failure";
        } catch(Exception e) {
            return "failure";
        }

    }

    @GetMapping(path = "transactions/{id}/getSeller")
    Integer getSeller(@PathVariable Integer id) {
        if(tr.findById(id).isPresent()) {
            Transactions t = tr.findById(id).get();
            return t.getUserSelling();
        }
        return 0;
    }

    @GetMapping(path = "transactions/{id}/getBuyer")
    Integer getBuyer(@PathVariable Integer id) {
        if(tr.findById(id).isPresent()) {
            Transactions t = tr.findById(id).get();
            return t.getUserBuying();
        }
        return 0;
    }

    @GetMapping(path = "transactions/{id}/getListing")
    Integer getListing(@PathVariable Integer id) {
        if(tr.findById(id).isPresent()) {
            Transactions t = tr.findById(id).get();
            return t.getListingInvolved();
        }
        return 0;
    }

    @GetMapping(path = "transactions/{id}/getListingTraded")
    Integer getListingTraded(@PathVariable Integer id) {
        if(tr.findById(id).isPresent()) {
            Transactions t = tr.findById(id).get();
            return t.getListingTraded();
        }
        return 0;
    }
}
