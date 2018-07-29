#include "storagedata.h"

StorageData::StorageData(QObject *parent) : QObject(parent),
  m_storage_type(STORAGE_TYPE_NULL),
  m_store_no(""),
  m_storage_no(""),
  m_x(0),
  m_y(0),
  m_canbe_null(true),
  m_canbe_raw(true),
  m_canbe_pack(true),
  m_canbe_tray(true),
  m_canbe_trash(true),
  m_canbe_product(true)
{

}
