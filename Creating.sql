-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`KorisnickiNalog`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`KorisnickiNalog` (
  `idKorisnickiNalog` INT NOT NULL AUTO_INCREMENT,
  `ime` VARCHAR(45) NOT NULL,
  `prezime` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `sifra` VARCHAR(45) NOT NULL,
  `telefon` VARCHAR(45) NULL,
  `postanski broj` VARCHAR(45) NULL,
  `poslednjeLoginVreme` TIMESTAMP NULL,
  `adresa` VARCHAR(45) NULL,
  PRIMARY KEY (`idKorisnickiNalog`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Uloga`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Uloga` (
  `idUloga` INT NOT NULL AUTO_INCREMENT,
  `naziv` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idUloga`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Privilegija`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Privilegija` (
  `idPrivilegija` INT NOT NULL AUTO_INCREMENT,
  `naziv` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idPrivilegija`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PromenaSopstvenihPodataka`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PromenaSopstvenihPodataka` (
  `idNalogaMenjac` INT NOT NULL,
  `idNalogaMenjan` INT NOT NULL,
  `napomenaPromene` VARCHAR(45) NULL,
  `vremePromene` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idNalogaMenjac`, `idNalogaMenjan`),
  INDEX `fk_Korisnicki nalog_has_Korisnicki nalog_Korisnicki nalog1_idx` (`idNalogaMenjan` ASC),
  INDEX `fk_Korisnicki nalog_has_Korisnicki nalog_Korisnicki nalog_idx` (`idNalogaMenjac` ASC),
  CONSTRAINT `fk_Korisnicki nalog_has_Korisnicki nalog_Korisnicki nalog`
    FOREIGN KEY (`idNalogaMenjac`)
    REFERENCES `mydb`.`KorisnickiNalog` (`idKorisnickiNalog`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Korisnicki nalog_has_Korisnicki nalog_Korisnicki nalog1`
    FOREIGN KEY (`idNalogaMenjan`)
    REFERENCES `mydb`.`KorisnickiNalog` (`idKorisnickiNalog`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Ima`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Ima` (
  `IDKorisnickiNalogUloga` INT NOT NULL,
  `vremeDobijanjaUloge` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IDUlogaKorisnickiNalog` INT NOT NULL,
  PRIMARY KEY (`IDKorisnickiNalogUloga`, `IDUlogaKorisnickiNalog`),
  INDEX `fk_Uloga_has_Korisnicki nalog_Korisnicki nalog1_idx` (`IDKorisnickiNalogUloga` ASC),
  INDEX `fk_KorisnickiNalogUloga_Uloga1_idx` (`IDUlogaKorisnickiNalog` ASC),
  CONSTRAINT `fk_Uloga_has_Korisnicki nalog_Korisnicki nalog1`
    FOREIGN KEY (`IDKorisnickiNalogUloga`)
    REFERENCES `mydb`.`KorisnickiNalog` (`idKorisnickiNalog`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_KorisnickiNalogUloga_Uloga1`
    FOREIGN KEY (`IDUlogaKorisnickiNalog`)
    REFERENCES `mydb`.`Uloga` (`idUloga`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Obezbedjuje`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Obezbedjuje` (
  `idPrivilegija` INT NOT NULL,
  `IDUlogaPrivilegija` INT NOT NULL,
  PRIMARY KEY (`idPrivilegija`, `IDUlogaPrivilegija`),
  INDEX `fk_Privilegija_has_Uloga_Uloga1_idx` (`IDUlogaPrivilegija` ASC),
  INDEX `fk_Privilegija_has_Uloga_Privilegija1_idx` (`idPrivilegija` ASC),
  CONSTRAINT `fk_Privilegija_has_Uloga_Privilegija1`
    FOREIGN KEY (`idPrivilegija`)
    REFERENCES `mydb`.`Privilegija` (`idPrivilegija`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Privilegija_has_Uloga_Uloga1`
    FOREIGN KEY (`IDUlogaPrivilegija`)
    REFERENCES `mydb`.`Uloga` (`idUloga`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`IzdanjeCasopisa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`IzdanjeCasopisa` (
  `issn` VARCHAR(9) NOT NULL,
  `naslov` VARCHAR(45) NOT NULL,
  `napomena` VARCHAR(45) NULL,
  `minRadova` INT NOT NULL,
  `maxRadova` VARCHAR(45) NOT NULL,
  `idKorisnika` INT NOT NULL,
  `letnje` TINYINT(1) NOT NULL,
  PRIMARY KEY (`issn`),
  INDEX `fk_IzdanjeCasopisa_KorisnickiNalog1_idx` (`idKorisnika` ASC),
  CONSTRAINT `fk_IzdanjeCasopisa_KorisnickiNalog1`
    FOREIGN KEY (`idKorisnika`)
    REFERENCES `mydb`.`KorisnickiNalog` (`idKorisnickiNalog`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Rad`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Rad` (
  `idRada` INT NOT NULL AUTO_INCREMENT,
  `naslov` VARCHAR(45) NOT NULL,
  `pdfStorageLinkId` VARCHAR(45) NOT NULL,
  `status` VARCHAR(45) NOT NULL,
  `objavljen` TINYINT(1) NOT NULL,
  `IzdanjeCasopisa_issn` VARCHAR(9) NOT NULL,
  PRIMARY KEY (`idRada`),
  INDEX `fk_Rad_IzdanjeCasopisa1_idx` (`IzdanjeCasopisa_issn` ASC),
  CONSTRAINT `fk_Rad_IzdanjeCasopisa1`
    FOREIGN KEY (`IzdanjeCasopisa_issn`)
    REFERENCES `mydb`.`IzdanjeCasopisa` (`issn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Pise`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Pise` (
  `IDRadKorisnickiNalog` INT NOT NULL,
  `IDKorisnickiNalogRad` INT NOT NULL,
  PRIMARY KEY (`IDRadKorisnickiNalog`, `IDKorisnickiNalogRad`),
  INDEX `fk_KorisnickiNalogUloga_has_Rad_Rad1_idx` (`IDRadKorisnickiNalog` ASC),
  INDEX `fk_AutorRad_KorisnickiNalog1_idx` (`IDKorisnickiNalogRad` ASC),
  CONSTRAINT `fk_KorisnickiNalogUloga_has_Rad_Rad1`
    FOREIGN KEY (`IDRadKorisnickiNalog`)
    REFERENCES `mydb`.`Rad` (`idRada`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AutorRad_KorisnickiNalog1`
    FOREIGN KEY (`IDKorisnickiNalogRad`)
    REFERENCES `mydb`.`KorisnickiNalog` (`idKorisnickiNalog`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Verzija`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Verzija` (
  `idRada` INT NOT NULL AUTO_INCREMENT,
  `pdfStorageLinkId` VARCHAR(45) NOT NULL,
  `datum` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `brojVerzije` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idRada`, `brojVerzije`),
  CONSTRAINT `fk_Verzija_Rad1`
    FOREIGN KEY (`idRada`)
    REFERENCES `mydb`.`Rad` (`idRada`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Recenzija`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Recenzija` (
  `komentarZaAutora` TEXT NOT NULL,
  `idKorisnik` INT NOT NULL,
  `komentarZaUrednika` TEXT NOT NULL,
  `Verzija_idRada` INT NOT NULL,
  `Verzija_brojVerzije` VARCHAR(45) NOT NULL,
  INDEX `fk_Recenzija_KorisnickiNalog1_idx` (`idKorisnik` ASC),
  PRIMARY KEY (`idKorisnik`, `Verzija_idRada`, `Verzija_brojVerzije`),
  INDEX `fk_Recenzija_Verzija1_idx` (`Verzija_idRada` ASC, `Verzija_brojVerzije` ASC),
  CONSTRAINT `fk_Recenzija_KorisnickiNalog1`
    FOREIGN KEY (`idKorisnik`)
    REFERENCES `mydb`.`KorisnickiNalog` (`idKorisnickiNalog`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Recenzija_Verzija1`
    FOREIGN KEY (`Verzija_idRada` , `Verzija_brojVerzije`)
    REFERENCES `mydb`.`Verzija` (`idRada` , `brojVerzije`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Sablon`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Sablon` (
  `idSablon` INT NOT NULL AUTO_INCREMENT,
  `naziv` VARCHAR(45) NOT NULL,
  `sadrzaj` TEXT NOT NULL,
  `idKorisikaAutora` INT NULL,
  PRIMARY KEY (`idSablon`),
  INDEX `fk_Sablon_KorisnickiNalog1_idx` (`idKorisikaAutora` ASC),
  CONSTRAINT `fk_Sablon_KorisnickiNalog1`
    FOREIGN KEY (`idKorisikaAutora`)
    REFERENCES `mydb`.`KorisnickiNalog` (`idKorisnickiNalog`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PoslataPoruka`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PoslataPoruka` (
  `idSablon` INT NOT NULL,
  `idPosiljalac` INT NOT NULL,
  `vreme` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `adresaPrimaoca` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idSablon`, `idPosiljalac`),
  INDEX `fk_Sablon_has_KorisnickiNalog_KorisnickiNalog1_idx` (`idPosiljalac` ASC),
  INDEX `fk_Sablon_has_KorisnickiNalog_Sablon1_idx` (`idSablon` ASC),
  CONSTRAINT `fk_Sablon_has_KorisnickiNalog_Sablon1`
    FOREIGN KEY (`idSablon`)
    REFERENCES `mydb`.`Sablon` (`idSablon`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Sablon_has_KorisnickiNalog_KorisnickiNalog1`
    FOREIGN KEY (`idPosiljalac`)
    REFERENCES `mydb`.`KorisnickiNalog` (`idKorisnickiNalog`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Casopis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Casopis` (
  `idCasopis` INT NOT NULL,
  `ime` VARCHAR(45) NOT NULL,
  `adresa` VARCHAR(90) NOT NULL,
  `issnMaska` VARCHAR(9) NOT NULL,
  `webStranica` VARCHAR(45) NULL,
  `IDKorisnickiNalogCasopis` INT NOT NULL,
  PRIMARY KEY (`idCasopis`),
  INDEX `fk_Casopis_KorisnickiNalog1_idx` (`IDKorisnickiNalogCasopis` ASC),
  CONSTRAINT `fk_Casopis_KorisnickiNalog1`
    FOREIGN KEY (`IDKorisnickiNalogCasopis`)
    REFERENCES `mydb`.`KorisnickiNalog` (`idKorisnickiNalog`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`OstavljaKomentar`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`OstavljaKomentar` (
  `sadrzaj` TEXT NOT NULL,
  `Rad_idRada` INT NOT NULL,
  `KorisnickiNalog_idKorisnick` INT NOT NULL,
  PRIMARY KEY (`Rad_idRada`, `KorisnickiNalog_idKorisnick`),
  INDEX `fk_KomentarNaRad_Rad1_idx` (`Rad_idRada` ASC),
  INDEX `fk_KomentarNaRad_KorisnickiNalog1_idx` (`KorisnickiNalog_idKorisnick` ASC),
  CONSTRAINT `fk_KomentarNaRad_Rad1`
    FOREIGN KEY (`Rad_idRada`)
    REFERENCES `mydb`.`Rad` (`idRada`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_KomentarNaRad_KorisnickiNalog1`
    FOREIGN KEY (`KorisnickiNalog_idKorisnick`)
    REFERENCES `mydb`.`KorisnickiNalog` (`idKorisnickiNalog`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Prijavljuje`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Prijavljuje` (
  `IDRadKorisnik` INT NOT NULL,
  `IDKorisnikRad` INT NOT NULL,
  `vremePrijave` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDRadKorisnik`, `IDKorisnikRad`),
  CONSTRAINT `fk_AutorPrijavljuje_AutorRad1`
    FOREIGN KEY (`IDRadKorisnik` , `IDKorisnikRad`)
    REFERENCES `mydb`.`Pise` (`IDRadKorisnickiNalog` , `IDKorisnickiNalogRad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Konferencija`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Konferencija` (
  `idKonferencija` INT NOT NULL AUTO_INCREMENT,
  `naziv` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idKonferencija`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Sala`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Sala` (
  `idSala` INT NOT NULL,
  `adresa` VARCHAR(45) NOT NULL,
  `kapacitet` INT NOT NULL,
  PRIMARY KEY (`idSala`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`OdrzavaSe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`OdrzavaSe` (
  `IDKonferencijaSala` INT NOT NULL,
  `IDSalaKonferencija` INT NOT NULL,
  PRIMARY KEY (`IDKonferencijaSala`, `IDSalaKonferencija`),
  INDEX `fk_Konferencija_has_Sala_Sala1_idx` (`IDSalaKonferencija` ASC),
  INDEX `fk_Konferencija_has_Sala_Konferencija1_idx` (`IDKonferencijaSala` ASC),
  CONSTRAINT `fk_Konferencija_has_Sala_Konferencija1`
    FOREIGN KEY (`IDKonferencijaSala`)
    REFERENCES `mydb`.`Konferencija` (`idKonferencija`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Konferencija_has_Sala_Sala1`
    FOREIGN KEY (`IDSalaKonferencija`)
    REFERENCES `mydb`.`Sala` (`idSala`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Izlaze`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Izlaze` (
  `idKonferencija` INT NOT NULL,
  `idSala` INT NOT NULL,
  `datum` DATE NOT NULL,
  `vreme` TIME NOT NULL,
  `radId` INT NOT NULL,
  `idKorisnikAutor` INT NOT NULL,
  PRIMARY KEY (`idKonferencija`, `idSala`, `radId`, `idKorisnikAutor`),
  INDEX `fk_AutorRad_has_KonferencijaSala_KonferencijaSala1_idx` (`idKonferencija` ASC, `idSala` ASC),
  INDEX `fk_AutorIzlaze_AutorRad1_idx` (`radId` ASC, `idKorisnikAutor` ASC),
  CONSTRAINT `fk_AutorRad_has_KonferencijaSala_KonferencijaSala1`
    FOREIGN KEY (`idKonferencija` , `idSala`)
    REFERENCES `mydb`.`OdrzavaSe` (`IDKonferencijaSala` , `IDSalaKonferencija`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AutorIzlaze_AutorRad1`
    FOREIGN KEY (`radId` , `idKorisnikAutor`)
    REFERENCES `mydb`.`Pise` (`IDRadKorisnickiNalog` , `IDKorisnickiNalogRad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Ucestvuje`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Ucestvuje` (
  `idRada` INT NOT NULL,
  `idKonferencija` INT NOT NULL,
  `datum` DATE NOT NULL,
  `status` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idRada`, `idKonferencija`),
  INDEX `fk_RadKonferencija_Rad1_idx` (`idRada` ASC),
  INDEX `fk_RadKonferencija_Konferencija1_idx` (`idKonferencija` ASC),
  CONSTRAINT `fk_RadKonferencija_Rad1`
    FOREIGN KEY (`idRada`)
    REFERENCES `mydb`.`Rad` (`idRada`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_RadKonferencija_Konferencija1`
    FOREIGN KEY (`idKonferencija`)
    REFERENCES `mydb`.`Konferencija` (`idKonferencija`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
