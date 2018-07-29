#ifndef STORAGEDATA_H
#define STORAGEDATA_H

#include <QObject>

class StorageData : public QObject
{
    Q_OBJECT

    //Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString store_no READ store_no WRITE setStore_no NOTIFY store_noChanged)
    Q_PROPERTY(QString storage_no READ storage_no WRITE setStorage_no NOTIFY storage_noChanged)
    Q_PROPERTY(int x READ x WRITE setX NOTIFY xChanged)
    Q_PROPERTY(int y READ y WRITE setY NOTIFY yChanged)
    Q_PROPERTY(bool canbe_null READ canbe_null WRITE setCanbe_null NOTIFY canbe_nullChanged)
    Q_PROPERTY(bool canbe_raw READ canbe_raw WRITE setCanbe_raw NOTIFY canbe_rawChanged)
    Q_PROPERTY(bool canbe_pack READ canbe_pack WRITE setCanbe_pack NOTIFY canbe_packChanged)
    Q_PROPERTY(bool canbe_tray READ canbe_tray WRITE setCanbe_tray NOTIFY canbe_trayChanged)
    Q_PROPERTY(bool canbe_trash READ canbe_trash WRITE setCanbe_trash NOTIFY canbe_trashChanged)
    Q_PROPERTY(bool canbe_product READ canbe_product WRITE setCanbe_product NOTIFY canbe_productChanged)
    Q_ENUMS(STORAGE_TYPE)
    Q_PROPERTY(STORAGE_TYPE storage_type READ storage_type WRITE setStorage_type NOTIFY storage_typeChanged)

public:
    enum STORAGE_TYPE{
        STORAGE_TYPE_NULL,
        STORAGE_TYPE_MATERIAL,
        STORAGE_TYPE_PACKING,
        STORAGE_TYPE_TRAY,
        STORAGE_TYPE_GARBAGE,
        STORAGE_TYPE_PRODUCT,
    };

    explicit StorageData(QObject *parent = nullptr);

    StorageData(const StorageData &b){
//        m_id = b.m_id;
        m_storage_no = b.m_storage_no;
        m_store_no = b.m_store_no;
        m_x = b.m_x;
        m_y = b.m_y;
        m_storage_type = b.m_storage_type;
        m_canbe_trash = b.m_canbe_trash;
        m_canbe_raw = b.m_canbe_raw;
        m_canbe_null = b.m_canbe_null;
        m_canbe_pack = b.m_canbe_pack;
        m_canbe_product = b.m_canbe_product;
        m_canbe_tray = b.m_canbe_tray;
    }

//    int id(){return m_id;}
    QString store_no(){return m_store_no;}
    QString storage_no(){return m_storage_no;}
    int x(){return m_x;}
    int y(){return m_y;}
    STORAGE_TYPE storage_type(){return m_storage_type;}
    bool canbe_null(){return m_canbe_null;}
    bool canbe_raw(){return m_canbe_raw;}
    bool canbe_pack(){return m_canbe_pack;}
    bool canbe_tray(){return m_canbe_tray;}
    bool canbe_trash(){return m_canbe_trash;}
    bool canbe_product(){return m_canbe_product;}

    //void setId(int _id){m_id=_id;emit idChanged(_id);}
    void setStore_no(QString _store_no){m_store_no = _store_no;emit store_noChanged(_store_no);}
    void setStorage_no(QString _storage_no){m_storage_no = _storage_no;emit storage_noChanged(_storage_no);}
    void setX(int _x){m_x=_x;emit xChanged(_x);}
    void setY(int _y){m_y=_y;emit yChanged(_y);}
    void setStorage_type(STORAGE_TYPE _storage_type){m_storage_type=_storage_type;emit storage_typeChanged(_storage_type);}
    void setCanbe_null(bool _canbe_null){m_canbe_null=_canbe_null;emit canbe_nullChanged(_canbe_null);}
    void setCanbe_raw(bool _canbe_raw){m_canbe_raw=_canbe_raw;emit canbe_rawChanged(_canbe_raw);}
    void setCanbe_pack(bool _canbe_pack){m_canbe_pack=_canbe_pack;emit canbe_packChanged(_canbe_pack);}
    void setCanbe_tray(bool _canbe_tray){m_canbe_tray=_canbe_tray;emit canbe_trayChanged(_canbe_tray);}
    void setCanbe_trash(bool _canbe_trash){m_canbe_trash=_canbe_trash;emit canbe_trashChanged(_canbe_trash);}
    void setCanbe_product(bool _canbe_product){m_canbe_product=_canbe_product;emit canbe_productChanged(_canbe_product);}

signals:
    //void idChanged(int _id);
    void store_noChanged(QString _store_no);
    void storage_noChanged(QString _storage_no);
    void xChanged(int _x);
    void yChanged(int _y);
    void storage_typeChanged(STORAGE_TYPE _storage_type);
    void canbe_nullChanged(bool _canbe_null);
    void canbe_rawChanged(bool _canbe_raw);
    void canbe_packChanged(bool _canbe_pack);
    void canbe_trayChanged(bool _canbe_tray);
    void canbe_trashChanged(bool _canbe_trash);
    void canbe_productChanged(bool _canbe_product);
public slots:

private:
    STORAGE_TYPE m_storage_type;
//    int m_id;
    QString m_store_no;
    QString m_storage_no;
    int m_x;
    int m_y;
    bool m_canbe_null;
    bool m_canbe_raw;
    bool m_canbe_pack;
    bool m_canbe_tray;
    bool m_canbe_trash;
    bool m_canbe_product;
};

#endif // STORAGEDATA_H
