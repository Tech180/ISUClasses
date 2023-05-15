package org.springframework.Listings.listing;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface ListingsRepository extends JpaRepository<Listings, Integer> {

   //Collection<Listings>
    Listings findById(int id);

    //void findById(int id);
    void deleteListing(int id);
    Listings createId(int id);
    //void createId(int id);

    //@Transactional
    void deleteById(int id);
    //Listings save(Listings listing);


}
